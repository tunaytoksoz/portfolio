//
//  PortfolioViewController.swift
//  portfolio
//
//  Created by Tunay Toksöz on 7.03.2023.
//

import UIKit
import Charts

class PortfolioViewController: UIViewController {
    
    let portfolioViewModel : PortfolioViewModel

    var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()
    
    init(portfolioViewModel: PortfolioViewModel) {
        self.portfolioViewModel = portfolioViewModel
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PortfolioViewController.createLayout())
        super.init(nibName: nil, bundle: nil)
        self.portfolioViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var portfolioArray : [collectionPortfolio] = [collectionPortfolio]()
    var chartArray : [UIView] = [UIView(),UIView(),UIView(),UIView()]
    var transactions : [Portfolios] = [Portfolios]()
    
    var keys : [[String]] = [[String]]()
    var values : [[Double]] = [[Double]]()
    var currencies : [String : Double] = [:]
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        title = "Portfolio App"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //CoreDataService(groupedData: GroupedData()).fakeDataGenerator()
    
        getData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: "header" , withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(PortfolioCell.self, forCellWithReuseIdentifier: PortfolioCell.reuseIdentifier)
        collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ChartCell.reuseIdentifier)
        collectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.reuseIdentifier)
        collectionView.register(TransactionsCell.self, forCellWithReuseIdentifier: TransactionsCell.reuseIdentifier)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
   
    func getData(){
        portfolioViewModel.getCurrency()
        portfolioViewModel.updateLastWeekChart()
        portfolioViewModel.updateWeeklySummaryChart()
        portfolioViewModel.updateMonthlyChart()
        portfolioViewModel.updateTransactionTable()
    }
    

     
    // MARK: - Objc Functions
    @objc func didTapAdd(){
        AlertManager().showActionSheet(on: self, currency: keys, actionHandler:  { text in
            guard let name = text else { return }
            
            AlertManager().showInputAlert(on: self, title: "\(name) Al", subtitle: "", actionTitle: "Al", actionHandler:  { text in
                
                if let text = text {
                    guard let text = Double(text) else { return AlertManager().showBasicAlert(on: self, title: "Error", message: "error", prefer: .alert)}
                    
                    if text > 0 {
                        let succes = self.portfolioViewModel.saveTransaction(portfolio: Portfolios(name: name, value: text), curr: self.currencies[name] ?? 1)
                        
                        if succes {
                            AlertManager().showBasicAlert(on: self, title: "Başarılı", message: "Satın Alınan Döviz Portföyünüze Eklendi.", prefer: .alert)
                            self.getData()
                            
                        } else {
                            AlertManager().showBasicAlert(on: self, title: "Error", message: "error", prefer: .alert)
                        }
                    } else {
                        AlertManager().showBasicAlert(on: self, title: "Error", message: "Geçersiz Değer", prefer: .alert)
                    }
                }
            })
        })
    }
    
    @objc func refresh(_ sender: AnyObject) {
            self.getData()
            refreshControl.endRefreshing()
        }

}

extension PortfolioViewController : PortfolioViewControllerDelegate{
    
    func updateCurrencyLabels(keys: [[String]], values: [[Double]], currencies: Currency, isSucces: Bool) {
        DispatchQueue.main.async {
            self.keys = keys
            self.values = values
            self.currencies = currencies.data
            self.portfolioViewModel.fillPortfolio(currencies: currencies.data)
            self.collectionView.reloadData()
        }
    }
    
    func fillPortfolio(collectionArray: [collectionPortfolio], isSucces: Bool) {
        DispatchQueue.main.async {
            self.portfolioArray = collectionArray
            self.portfolioViewModel.createPieChart(collectionArray: collectionArray)
            self.collectionView.reloadData()
        }
    }
    
    func updateTransactionsTable(porfolio: [Portfolios], isSucces: Bool) {
        if isSucces{
            self.transactions = porfolio
            self.collectionView.reloadData()
        }
    }
    
    
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
}


