//
//  PortfolioViewController.swift
//  portfolio
//
//  Created by Tunay Toksöz on 7.03.2023.
//

import UIKit
import Charts

class PortfolioViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let currencyViewModel : currencyViewModel
    
    private let cdViewModel : coreDataViewModel
    
    var collectionView: UICollectionView!
    
    var portfolioArray : [collectionPortfolio] = [collectionPortfolio]()
    
    var chartArray : [UIView] = [UIView]()
    
    var keys : [[String]] = [[String]]()
    
    var values : [[Double]] = [[Double]]()
    
    init(currencyViewModel: currencyViewModel, cdViewModel: coreDataViewModel) {
        self.currencyViewModel = currencyViewModel
        self.cdViewModel = cdViewModel
        super.init(nibName: nil, bundle: nil)
        self.currencyViewModel.output = self
        self.cdViewModel.cdOutput = self
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PortfolioViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        title = "Portfolio App"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        currencyViewModel.getFullApi()
        currencyViewModel.convertPortfolio()
        currencyViewModel.updateChart() // piechart
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PortfolioCell.self, forCellWithReuseIdentifier: PortfolioCell.reuseIdentifier)
        collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ChartCell.reuseIdentifier)
        collectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.reuseIdentifier)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = portfolioArray[indexPath.item].name
        let price = portfolioArray[indexPath.item].price
        
        if indexPath.section == 2 {
            AlertManager().showInputAlert(on: self, title: "\(name) Sat", subtitle: "Lütfen Miktar Girin", actionTitle: "Sat", actionHandler:  { text in
                guard let text = Double(text ?? "0") else { return }
                if text <= price {
                    let succes = self.cdViewModel.saveObject(portfolio: portfolio(name: name, value: -text))
                    if succes {
                        AlertManager().showBasicAlert(on: self, title: "Başarılı", message: "Satıldı.", prefer: .alert)
                        self.currencyViewModel.convertPortfolio()
                        self.currencyViewModel.updateChart() // piechart
                    }
                } else {
                    AlertManager().showBasicAlert(on: self, title: "Başarısız", message: "Döviz Tutarını Kontrol Edin!", prefer: .alert)
                }
            })
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.reuseIdentifier, for: indexPath) as? CurrencyCell else {
                return UICollectionViewCell()
            }
            cell.configure(key: keys[indexPath.item], value: values[indexPath.item], isSucces: true)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCell.reuseIdentifier, for: indexPath) as? ChartCell else {
                return UICollectionViewCell()
            }
            cell.configure(view: chartArray[indexPath.item])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioCell.reuseIdentifier, for: indexPath) as? PortfolioCell else {
                return UICollectionViewCell()
            }
            cell.configure(collectionPortfolio: portfolioArray[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return keys.count
        case 1:
            return chartArray.count
        case 2:
            return portfolioArray.count
        default:
            return 1
        }
    }
}

extension PortfolioViewController : currencyViewModelOutput, cdViewModelOutput{
    
    
    func updateCurrencyLabels(keys: [[String]], values: [[Double]], isSucces: Bool) {
        DispatchQueue.main.async {
            self.keys = keys
            self.values = values
            self.collectionView.reloadData()
        }
    }
    
    
    
    func updatePiechart(view: UIView) {
        DispatchQueue.main.async {
            self.chartArray.removeAll()
            self.chartArray.append(view)
            self.collectionView.reloadData()
        }
    }

    
    func updateCurrencyLabels(eur: Double, gbp: Double, rub: Double, usd: Double, isSucces: Bool) {
        
    }
    
    func fillPortfolio(collectionArray: [collectionPortfolio]) {
        DispatchQueue.main.async {
            self.portfolioArray = collectionArray
            self.collectionView.reloadData()
        }
    }
    
    

    
    
    @objc func didTapAdd(){
        AlertManager().showActionSheet(on: self, currency: keys, actionHandler:  { text in
            guard let name = text else { return }
            
            AlertManager().showInputAlert(on: self, title: "\(name) Al", subtitle: "", actionTitle: "Al", actionHandler:  { text in
                
                guard let text = Double(text ?? "0") else { return }
                let succes = self.cdViewModel.saveObject(portfolio: portfolio(name: name, value: text))
                if succes {
                    AlertManager().showBasicAlert(on: self, title: "Başarılı", message: "Satın Alınan Döviz Portföyünüze Eklendi.", prefer: .alert)
                    self.currencyViewModel.convertPortfolio()
                    self.currencyViewModel.updateChart() // piechart
                }
            })
        })
    }
}

extension PortfolioViewController {
    
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            switch sectionIndex {
            case 0:
                let item = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
               
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitems: [item])
               
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .continuous
                return section
            case 1 :
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .groupPagingCentered
                
                return section
            default:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(150)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }

 
}


