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
    
    var currency : Currency?
    
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
        
        currencyViewModel.getCurrencyData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PortfolioCell.self, forCellWithReuseIdentifier: PortfolioCell.reuseIdentifier)
        collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ChartCell.reuseIdentifier)
        collectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.reuseIdentifier)
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.reuseIdentifier, for: indexPath) as? CurrencyCell else {
                return UICollectionViewCell()
            }
            cell.configure(currency: currency ?? Currency(data: dataCurrency(eur: 0, gbp: 0, rub: 0, usd: 0)))
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCell.reuseIdentifier, for: indexPath) as? ChartCell else {
                return UICollectionViewCell()
            }
            cell.configure(portfolio: Portfolio(eur: 10, gbp: 30, rub: 20, usd: 40))
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioCell.reuseIdentifier, for: indexPath) as? PortfolioCell else {
                return UICollectionViewCell()
            }
            cell.configure(name: "test", symbol: "€", price: 1, priceTL: 2)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 5
        default:
            return 1
        }
    }
}

extension PortfolioViewController : currencyViewModelOutput, cdViewModelOutput{
    
    func updateCurrencyLabels(eur: Double, gbp: Double, rub: Double, usd: Double, isSucces: Bool) {
        DispatchQueue.main.async {
            print(eur)
            self.currency = Currency(data: dataCurrency(eur: 1 / eur, gbp: 1 / gbp, rub: 1 / rub, usd: 1 / usd))
            self.collectionView.reloadData()
        }
    }
    
    func convertTL(eur: Double, gbp: Double, rub: Double, usd: Double) {
        //
    }
    
    func updatePiechart(eur: Double, gbp: Double, rub: Double, usd: Double) {
        //
    }
    
    func updatePortfolioLabels(eur: Double, gbp: Double, rub: Double, usd: Double, isSucces: Bool) {
        //
    }
    
    
    @objc func didTapAdd(){
        print("test")
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


