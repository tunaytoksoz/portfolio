//
//  PortfolioViewController.swift
//  portfolio
//
//  Created by Tunay Toksöz on 7.03.2023.
//

import UIKit
import Charts

class PortfolioViewController: UIViewController {
    
    private let currencyViewModel : currencyViewModel
    private let cdViewModel : coreDataViewModel
    
    var collectionView: UICollectionView!
    
    var portfolioArray : [collectionPortfolio] = [collectionPortfolio]()
    var chartArray : [UIView] = [UIView(),UIView(),UIView(),UIView()]
    
    var keys : [[String]] = [[String]]()
    var values : [[Double]] = [[Double]]()
    var currencies : [String : Double] = [:]
    
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
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //CoreDataService().fakeGenerator()
        currencyViewModel.getCurrency()
        currencyViewModel.convertPortfolio()
        currencyViewModel.updatePieChart()
        cdViewModel.updateWeekChart()
        cdViewModel.updateWeekSummaryGraphic()
        cdViewModel.updateMonthlyGraphic()
       
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PortfolioCell.self, forCellWithReuseIdentifier: PortfolioCell.reuseIdentifier)
        collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ChartCell.reuseIdentifier)
        collectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.reuseIdentifier)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            let name = portfolioArray[indexPath.item].name
            let price = portfolioArray[indexPath.item].price
            
            AlertManager().showInputAlert(on: self, title: "\(name) Sat", subtitle: "Lütfen Miktar Girin", actionTitle: "Sat", actionHandler:  { text in
                guard let text = Double(text ?? "0") else { return }
                if text <= price {
                    let succes = self.cdViewModel.saveObject(portfolio: portfolio(name: name, value: -text), curr: self.currencies[name] ?? 1)
                    if succes {
                        AlertManager().showBasicAlert(on: self, title: "Başarılı", message: "Satıldı.", prefer: .alert)
                        self.currencyViewModel.convertPortfolio()
                        self.currencyViewModel.updatePieChart()
                        self.cdViewModel.updateWeekChart()
                        self.cdViewModel.updateWeekSummaryGraphic()
                        self.cdViewModel.updateMonthlyGraphic()
                    }
                } else {
                    AlertManager().showBasicAlert(on: self, title: "Başarısız", message: "Döviz Tutarını Kontrol Edin!", prefer: .alert)
                }
            })
        }
    }
     
    // MARK: - Objc Functions
    @objc func didTapAdd(){
        AlertManager().showActionSheet(on: self, currency: keys, actionHandler:  { text in
            guard let name = text else { return }
            
            AlertManager().showInputAlert(on: self, title: "\(name) Al", subtitle: "", actionTitle: "Al", actionHandler:  { text in
                
                guard let text = Double(text ?? "0") else { return }
                let succes = self.cdViewModel.saveObject(portfolio: portfolio(name: name, value: text), curr: self.currencies[name] ?? 1)
                
                if succes {
                    AlertManager().showBasicAlert(on: self, title: "Başarılı", message: "Satın Alınan Döviz Portföyünüze Eklendi.", prefer: .alert)
                    self.currencyViewModel.convertPortfolio()
                    self.currencyViewModel.updatePieChart() // piechart
                    self.cdViewModel.updateWeekChart()
                    self.cdViewModel.updateWeekSummaryGraphic()
                    self.cdViewModel.updateMonthlyGraphic()
                    
                } else {
                    AlertManager().showBasicAlert(on: self, title: "Error", message: "error", prefer: .alert)
                }
            })
        })
    }

}

extension PortfolioViewController : currencyViewModelOutput, cdViewModelOutput{
    func updateCharts(view: UIView, type: chartType) {
        DispatchQueue.main.async {
            switch type {
            case .pie:
                self.chartArray[0] = view
                self.collectionView.reloadData()
            case .barDay:
                self.chartArray[1] = view
                self.collectionView.reloadData()
            case .barWeek:
                self.chartArray[2] = view
                self.collectionView.reloadData()
            case .barMonth:
                self.chartArray[3] = view
                self.collectionView.reloadData()
            }
        }
    }
    
    func updateCurrencyLabels(keys: [[String]], values: [[Double]], currencies: [String : Double], isSucces: Bool) {
        DispatchQueue.main.async {
            self.keys = keys
            self.values = values
            self.currencies = currencies
            self.collectionView.reloadData()
        }
    }
    
    func fillPortfolio(collectionArray: [collectionPortfolio]) {
        DispatchQueue.main.async {
            self.portfolioArray = collectionArray
            self.collectionView.reloadData()
        }
    }
}


