//
//  ViewController.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import UIKit
import Charts

class ViewController: UIViewController, currencyViewModelOutput, cdViewModelOutput {
 
    private let currencyViewModel : currencyViewModel
    
    private let cdViewModel : coreDataViewModel
    
    private let alertManager = AlertManager()
    
    private var portfolioArray : [(eur : Double, gbp : Double, rub : Double, usd : Double)] = []
    
    init(currencyViewModel: currencyViewModel, cdViewModel: coreDataViewModel) {
        self.currencyViewModel = currencyViewModel
        self.cdViewModel = cdViewModel
        super.init(nibName: nil, bundle: nil)
        self.currencyViewModel.output = self
        self.cdViewModel.cdOutput = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let currView : UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let pieChart : PieChartView = {
        let pieChart = PieChartView()
        pieChart.drawHoleEnabled = false
        pieChart.rotationAngle = 0
        pieChart.isUserInteractionEnabled = false
       return pieChart
    }()
    
    private let errorCurrencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "No Data!"
        label.isHidden = true
        return label
    }()
    
    private let eurLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "EUR: "
        return label
    }()
    
    private let gbpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "GBP: "
        return label
    }()
    
    private let rubLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "RUB: "
        return label
    }()
    
    private let usdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "USD: "
        return label
    }()
    
    private let portfolioTitlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Portföyüm"
        return label
    }()
    
    private let eurPortfoliolabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "EUR: "
        return label
    }()
    
    private let eurNumberPortfoliolabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = ""
        return label
    }()
    
    private let gbpPortfoliolabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "GBP: "
        return label
    }()
    
    private let gbpNumberPortfoliolabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = ""
        return label
    }()
    
    private let rubPortfoliolabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "RUB: "
        return label
    }()
    
    private let rubNumberPortfoliolabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = ""
        return label
    }()
    
    private let usdPortfoliolabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "USD: "
        return label
    }()
    
    private let usdNumberPortfoliolabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = ""
        return label
    }()
    
    private let totalPortfolioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "TOPLAM: "
        return label
    }()
    
    private let totalNumberPortfolioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = ""
        return label
    }()
    
    private let eurSellbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Sat", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let eurBuybutton: UIButton = {
        let button = UIButton()
        button.setTitle("Al", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()

    private let gbpSellbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Sat", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()

    private let gbpBuybutton: UIButton = {
        let button = UIButton()
        button.setTitle("Al", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()

    private let rubSellbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Sat", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let rubBuybutton: UIButton = {
        let button = UIButton()
        button.setTitle("Al", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let usdSellbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Sat", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let usdBuybutton: UIButton = {
        let button = UIButton()
        button.setTitle("Al", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()


    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
     

        
        currencyViewModel.getCurrencyData()  // currency view
        currencyViewModel.updateChart() // piechart
        cdViewModel.getPortfolio() // portföy
        currencyViewModel.convertPortfolio() // portföy
        
        self.eurSellbutton.addTarget(self, action: #selector(didTapEurSellButton), for: .touchUpInside)
        self.eurBuybutton.addTarget(self, action: #selector(didTapEurBuyButton), for: .touchUpInside)
        self.gbpSellbutton.addTarget(self, action: #selector(didTapGbpSellButton), for: .touchUpInside)
        self.gbpBuybutton.addTarget(self, action: #selector(didTapGbpBuyButton), for: .touchUpInside)
        self.rubSellbutton.addTarget(self, action: #selector(didTapRubSellButton), for: .touchUpInside)
        self.rubBuybutton.addTarget(self, action: #selector(didTapRubBuyButton), for: .touchUpInside)
        self.usdSellbutton.addTarget(self, action: #selector(didTapUsdSellButton), for: .touchUpInside)
        self.usdBuybutton.addTarget(self, action: #selector(didTapUsdBuyButton), for: .touchUpInside)
        
        setupUI()
    }
    
    // MARK: - Functions
    
    func updateCurrencyLabels(eur: Double, gbp: Double, rub: Double, usd: Double, isSucces: Bool) {
        if isSucces == true {
            DispatchQueue.main.async {
                self.eurLabel.text! = "EUR:" + String(format: "%.4f", 1 / eur)
                self.gbpLabel.text! = "GBP:" + String(format: "%.4f", 1 / gbp)
                self.rubLabel.text! = "RUB:" + String(format: "%.4f", 1 / rub)
                self.usdLabel.text! = "USD:" + String(format: "%.4f", 1 / usd)
            }
        } else {
            DispatchQueue.main.async {
                self.errorCurrencyLabel.isHidden = false
            }
        }
    }
    
    func updatePortfolioLabels(eur: Double, gbp: Double, rub: Double, usd: Double, isSucces: Bool) {
        if isSucces == true {
            self.portfolioArray.append((eur,gbp,rub,usd))
            DispatchQueue.main.async {
                self.eurPortfoliolabel.text! = "EUR:  \(eur.formatted())  €"
                self.gbpPortfoliolabel.text! = "GBP:  \(gbp.formatted())  £"
                self.rubPortfoliolabel.text! = "RUB:  \(rub.formatted())  ₽"
                self.usdPortfoliolabel.text! = "USD:  \(usd.formatted())  $"
            }
        } else {
            //
        }
    }
    
    func convertTL(eur: Double, gbp: Double, rub: Double, usd: Double) {
        DispatchQueue.main.async {
            self.eurNumberPortfoliolabel.text! = String(format: "%.2f ₺", eur)
            self.gbpNumberPortfoliolabel.text! = String(format: "%.2f ₺", gbp)
            self.rubNumberPortfoliolabel.text! = String(format: "%.2f ₺", rub)
            self.usdNumberPortfoliolabel.text! = String(format: "%.2f ₺", usd)
            self.totalNumberPortfolioLabel.text! = String(format: "%.2f ₺", eur+gbp+rub+usd)
        }
    }
    
    func updatePiechart(eur: Double, gbp: Double, rub: Double, usd: Double) {
        
        DispatchQueue.main.async {
            
            var entryPortfolios = [PieChartDataEntry]()
            let eur = PieChartDataEntry(value: eur, label: "eur")
            let gbp = PieChartDataEntry(value: gbp, label: "gbp")
            let rub = PieChartDataEntry(value: rub, label: "rub")
            let usd = PieChartDataEntry(value: usd, label: "usd")

            entryPortfolios = [eur,gbp,rub,usd]
            let charDataSet = PieChartDataSet(entries: entryPortfolios)
            print(entryPortfolios)
            let chartData = PieChartData(dataSet: charDataSet)
            self.pieChart.data = chartData
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            formatter.multiplier = 1
            formatter.percentSymbol = "%"
            
            let setFormatter = DefaultValueFormatter(formatter: formatter)
            chartData.setValueFormatter(setFormatter)
        
            let colors : [NSUIColor] = [.purple, .black, .blue, .red]
            charDataSet.colors = colors
            
        }
    }
    
    // MARK: - @objc Functions
    
    // MARK: - Eur Buttons
    @objc func didTapEurSellButton(){
        alertManager.showInputAlert(on: self, title: "Euro Sat", subtitle: "Portföydeki Toplam €: \(self.portfolioArray[0].eur)", actionTitle: "Sat", actionHandler:  { text in
            guard let text = Double(text ?? "0") else { return }
            
            if text > self.portfolioArray[0].eur {
                self.alertManager.showBasicAlert(on: self, title: "Hata", message: "Girilen tutar portföyünüzden fazla.")
            } else {
                let isSelled = self.cdViewModel.saveObject(portfolio: Portfolio(eur: -text, gbp: 0, rub: 0, usd: 0))
                
                if isSelled {
                    self.portfolioArray.removeAll()
                    self.currencyViewModel.getCurrencyData()
                    self.cdViewModel.getPortfolio()
                    self.currencyViewModel.convertPortfolio()
                    self.currencyViewModel.updateChart()
                    self.alertManager.showBasicAlert(on: self, title: "Satıldı.", message: "İşleminiz başarılı bir şekilde gerçekleşti")
                }
            }
            
        })
    }
    
    @objc func didTapEurBuyButton(){
        alertManager.showInputAlert(on: self, title: "Euro Al", subtitle: "Portföydeki Toplam €: \(self.portfolioArray[0].eur)", actionTitle: "Al", actionHandler:  { text in
            guard let text = Double(text ?? "0") else { return }
            
                let isBought = self.cdViewModel.saveObject(portfolio: Portfolio(eur: text, gbp: 0, rub: 0, usd: 0))
            
                if isBought {
                    self.portfolioArray.removeAll()
                    self.currencyViewModel.getCurrencyData()
                    self.cdViewModel.getPortfolio()
                    self.currencyViewModel.convertPortfolio()
                    self.currencyViewModel.updateChart()
                    self.alertManager.showBasicAlert(on: self, title: "Alındı.", message: "İşleminiz başarılı bir şekilde gerçekleşti")
                }
        })
    }
    
    // MARK: - Gbp Buttons
    @objc func didTapGbpSellButton(){
        
        alertManager.showInputAlert(on: self, title: "Pound Sat", subtitle: "Portföydeki Toplam £: \(self.portfolioArray[0].gbp)", actionTitle: "Sat", actionHandler:  { text in
            guard let text = Double(text ?? "0") else { return }
            
            if text > self.portfolioArray[0].gbp {
                self.alertManager.showBasicAlert(on: self, title: "Hata", message: "Girilen tutar portföyünüzden fazla.")
            } else {
                let isSelled = self.cdViewModel.saveObject(portfolio: Portfolio(eur: 0, gbp: -text, rub: 0, usd: 0))
                
                if isSelled {
                    self.portfolioArray.removeAll()
                    self.currencyViewModel.getCurrencyData()
                    self.cdViewModel.getPortfolio()
                    self.currencyViewModel.convertPortfolio()
                    self.currencyViewModel.updateChart()
                    self.alertManager.showBasicAlert(on: self, title: "Satıldı.", message: "İşleminiz başarılı bir şekilde gerçekleşti")
                }
            }
            
        })
    }
    
    @objc func didTapGbpBuyButton(){
        alertManager.showInputAlert(on: self, title: "Pound Al", subtitle: "Portföydeki Toplam £: \(self.portfolioArray[0].gbp)", actionTitle: "Al", actionHandler:  { text in
            guard let text = Double(text ?? "0") else { return }
            
                let isBought = self.cdViewModel.saveObject(portfolio: Portfolio(eur: 0, gbp: text, rub: 0, usd: 0))
            
                if isBought {
                    self.portfolioArray.removeAll()
                    self.currencyViewModel.getCurrencyData()
                    self.cdViewModel.getPortfolio()
                    self.currencyViewModel.convertPortfolio()
                    self.currencyViewModel.updateChart()
                    self.alertManager.showBasicAlert(on: self, title: "Alındı.", message: "İşleminiz başarılı bir şekilde gerçekleşti")
                }
        })
    }

    
    // MARK: - Rub Buttons
    @objc func didTapRubSellButton(){
        alertManager.showInputAlert(on: self, title: "Ruble Sat", subtitle: "Portföydeki Toplam ₽: \(self.portfolioArray[0].rub)", actionTitle: "Sat", actionHandler:  { text in
            guard let text = Double(text ?? "0") else { return }
            
            if text > self.portfolioArray[0].rub {
                self.alertManager.showBasicAlert(on: self, title: "Hata", message: "Girilen tutar portföyünüzden fazla.")
            } else {
                let isSelled = self.cdViewModel.saveObject(portfolio: Portfolio(eur: 0, gbp: 0, rub: -text, usd: 0))
                
                if isSelled {
                    self.portfolioArray.removeAll()
                    self.currencyViewModel.getCurrencyData()
                    self.cdViewModel.getPortfolio()
                    self.currencyViewModel.convertPortfolio()
                    self.currencyViewModel.updateChart()
                    self.alertManager.showBasicAlert(on: self, title: "Satıldı.", message: "İşleminiz başarılı bir şekilde gerçekleşti")
                }
            }
            
        })
    }
    
    @objc func didTapRubBuyButton(){
        alertManager.showInputAlert(on: self, title: "Ruble Al", subtitle: "Portföydeki Toplam ₽: \(self.portfolioArray[0].rub)", actionTitle: "Al", actionHandler:  { text in
            guard let text = Double(text ?? "0") else { return }
            
                let isBought = self.cdViewModel.saveObject(portfolio: Portfolio(eur: 0, gbp: 0, rub: text, usd: 0))
            
                if isBought {
                    self.portfolioArray.removeAll()
                    self.currencyViewModel.getCurrencyData()
                    self.cdViewModel.getPortfolio()
                    self.currencyViewModel.convertPortfolio()
                    self.currencyViewModel.updateChart()
                    self.alertManager.showBasicAlert(on: self, title: "Alındı.", message: "İşleminiz başarılı bir şekilde gerçekleşti")
                }
        })
    }

    
    // MARK: - Usd Buttons
    @objc func didTapUsdSellButton(){
        alertManager.showInputAlert(on: self, title: "Dolar Sat", subtitle: "Portföydeki Toplam $: \(self.portfolioArray[0].usd)", actionTitle: "Sat", actionHandler:  { text in
            guard let text = Double(text ?? "0") else { return }
            
            if text > self.portfolioArray[0].usd {
                self.alertManager.showBasicAlert(on: self, title: "Hata", message: "Girilen tutar portföyünüzden fazla.")
            } else {
                let isSelled = self.cdViewModel.saveObject(portfolio: Portfolio(eur: 0, gbp: 0, rub: 0, usd: -text))
                
                if isSelled {
                    self.portfolioArray.removeAll()
                    self.currencyViewModel.getCurrencyData()
                    self.cdViewModel.getPortfolio()
                    self.currencyViewModel.convertPortfolio()
                    self.currencyViewModel.updateChart()
                    self.alertManager.showBasicAlert(on: self, title: "Satıldı.", message: "İşleminiz başarılı bir şekilde gerçekleşti")
                }
            }
            
        })
    }
    
    @objc func didTapUsdBuyButton(){
        alertManager.showInputAlert(on: self, title: "Dolar Al", subtitle: "Portföydeki Toplam $: \(self.portfolioArray[0].usd)", actionTitle: "Al", actionHandler:  { text in
            guard let text = Double(text ?? "0") else { return }
            
                let isBought = self.cdViewModel.saveObject(portfolio: Portfolio(eur: 0, gbp: 0, rub: 0, usd: text))
            
                if isBought {
                    self.portfolioArray.removeAll()
                    self.currencyViewModel.getCurrencyData()
                    self.cdViewModel.getPortfolio()
                    self.currencyViewModel.convertPortfolio()
                    self.currencyViewModel.updateChart()
                    self.alertManager.showBasicAlert(on: self, title: "Alındı.", message: "İşleminiz başarılı bir şekilde gerçekleşti")
                }
        })
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.addSubview(currView)
        self.currView.addSubview(errorCurrencyLabel)
        self.currView.addSubview(eurLabel)
        self.currView.addSubview(gbpLabel)
        self.currView.addSubview(rubLabel)
        self.currView.addSubview(usdLabel)
        self.view.addSubview(pieChart)
        self.view.addSubview(portfolioTitlelabel)
        self.view.addSubview(eurPortfoliolabel)
        self.view.addSubview(eurNumberPortfoliolabel)
        self.view.addSubview(eurSellbutton)
        self.view.addSubview(eurBuybutton)
        self.view.addSubview(gbpPortfoliolabel)
        self.view.addSubview(gbpNumberPortfoliolabel)
        self.view.addSubview(gbpBuybutton)
        self.view.addSubview(gbpSellbutton)
        self.view.addSubview(rubPortfoliolabel)
        self.view.addSubview(rubNumberPortfoliolabel)
        self.view.addSubview(rubBuybutton)
        self.view.addSubview(rubSellbutton)
        self.view.addSubview(usdPortfoliolabel)
        self.view.addSubview(usdNumberPortfoliolabel)
        self.view.addSubview(usdBuybutton)
        self.view.addSubview(usdSellbutton)
        self.view.addSubview(totalPortfolioLabel)
        self.view.addSubview(totalNumberPortfolioLabel)
        
        
        currView.translatesAutoresizingMaskIntoConstraints = false
        errorCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        eurLabel.translatesAutoresizingMaskIntoConstraints = false
        gbpLabel.translatesAutoresizingMaskIntoConstraints = false
        rubLabel.translatesAutoresizingMaskIntoConstraints = false
        usdLabel.translatesAutoresizingMaskIntoConstraints = false
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        portfolioTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        eurPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        eurNumberPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        eurBuybutton.translatesAutoresizingMaskIntoConstraints = false
        eurSellbutton.translatesAutoresizingMaskIntoConstraints = false
        gbpPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        gbpNumberPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        gbpBuybutton.translatesAutoresizingMaskIntoConstraints = false
        gbpSellbutton.translatesAutoresizingMaskIntoConstraints = false
        rubPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        rubNumberPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        rubBuybutton.translatesAutoresizingMaskIntoConstraints = false
        rubSellbutton.translatesAutoresizingMaskIntoConstraints = false
        usdPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        usdNumberPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        usdBuybutton.translatesAutoresizingMaskIntoConstraints = false
        usdSellbutton.translatesAutoresizingMaskIntoConstraints = false
        totalPortfolioLabel.translatesAutoresizingMaskIntoConstraints = false
        totalNumberPortfolioLabel.translatesAutoresizingMaskIntoConstraints = false
        
       
        
        
        NSLayoutConstraint.activate([
            
            // MARK: - Currency View
            currView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            currView.heightAnchor.constraint(equalToConstant: 50),
            currView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            currView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            
            errorCurrencyLabel.topAnchor.constraint(equalTo: self.currView.topAnchor),
            errorCurrencyLabel.bottomAnchor.constraint(equalTo: self.currView.bottomAnchor),
            errorCurrencyLabel.leadingAnchor.constraint(equalTo: self.currView.leadingAnchor),
            errorCurrencyLabel.trailingAnchor.constraint(equalTo: self.currView.trailingAnchor),
            
            eurLabel.topAnchor.constraint(equalTo: self.currView.safeAreaLayoutGuide.topAnchor, constant: 5),
            eurLabel.heightAnchor.constraint(equalToConstant: 15),
            eurLabel.leadingAnchor.constraint(equalTo: self.currView.leadingAnchor, constant: 5),
            
            gbpLabel.topAnchor.constraint(equalTo: self.currView.safeAreaLayoutGuide.topAnchor, constant: 5),
            gbpLabel.heightAnchor.constraint(equalToConstant: 15),
            gbpLabel.trailingAnchor.constraint(equalTo: self.currView.trailingAnchor, constant: -5),
            
            usdLabel.bottomAnchor.constraint(equalTo: self.currView.bottomAnchor, constant: -5),
            usdLabel.heightAnchor.constraint(equalToConstant: 15),
            usdLabel.centerXAnchor.constraint(equalTo: self.eurLabel.centerXAnchor),
            
            rubLabel.bottomAnchor.constraint(equalTo: self.currView.bottomAnchor, constant: -5),
            rubLabel.heightAnchor.constraint(equalToConstant: 15),
            rubLabel.centerXAnchor.constraint(equalTo: self.gbpLabel.centerXAnchor),
            
            // MARK: - PieChart View
            pieChart.topAnchor.constraint(equalTo: currView.bottomAnchor),
            pieChart.heightAnchor.constraint(equalToConstant: 300),
            pieChart.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            pieChart.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            // MARK: - Portfolio
            portfolioTitlelabel.topAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: 30),
            portfolioTitlelabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            portfolioTitlelabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            eurPortfoliolabel.topAnchor.constraint(equalTo: portfolioTitlelabel.bottomAnchor, constant: 15),
            eurPortfoliolabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30),
            eurPortfoliolabel.heightAnchor.constraint(equalToConstant: 30),
            
            eurNumberPortfoliolabel.topAnchor.constraint(equalTo: portfolioTitlelabel.bottomAnchor, constant: 15),
            eurNumberPortfoliolabel.leadingAnchor.constraint(equalTo: self.eurPortfoliolabel.trailingAnchor, constant: 15),
            eurNumberPortfoliolabel.heightAnchor.constraint(equalToConstant: 30),
            
            eurSellbutton.topAnchor.constraint(equalTo: portfolioTitlelabel.bottomAnchor, constant: 15),
            eurSellbutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            eurSellbutton.widthAnchor.constraint(equalToConstant: 50),
            eurSellbutton.heightAnchor.constraint(equalToConstant: 30),
            
            eurBuybutton.topAnchor.constraint(equalTo: portfolioTitlelabel.bottomAnchor, constant: 15),
            eurBuybutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -90),
            eurBuybutton.widthAnchor.constraint(equalToConstant: 50),
            eurBuybutton.heightAnchor.constraint(equalToConstant: 30),
            
            gbpPortfoliolabel.topAnchor.constraint(equalTo: eurPortfoliolabel.bottomAnchor, constant: 15),
            gbpPortfoliolabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30),
            gbpPortfoliolabel.heightAnchor.constraint(equalToConstant: 30),
            
            gbpNumberPortfoliolabel.topAnchor.constraint(equalTo: eurNumberPortfoliolabel.bottomAnchor, constant: 15),
            gbpNumberPortfoliolabel.leadingAnchor.constraint(equalTo: self.gbpPortfoliolabel.trailingAnchor, constant: 15),
            gbpNumberPortfoliolabel.heightAnchor.constraint(equalToConstant: 30),
            
            gbpSellbutton.topAnchor.constraint(equalTo: eurNumberPortfoliolabel.bottomAnchor, constant: 15),
            gbpSellbutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            gbpSellbutton.widthAnchor.constraint(equalToConstant: 50),
            gbpSellbutton.heightAnchor.constraint(equalToConstant: 30),
            
            gbpBuybutton.topAnchor.constraint(equalTo: eurNumberPortfoliolabel.bottomAnchor, constant: 15),
            gbpBuybutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -90),
            gbpBuybutton.widthAnchor.constraint(equalToConstant: 50),
            gbpBuybutton.heightAnchor.constraint(equalToConstant: 30),
            
            rubPortfoliolabel.topAnchor.constraint(equalTo: gbpPortfoliolabel.bottomAnchor, constant: 15),
            rubPortfoliolabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30),
            rubPortfoliolabel.heightAnchor.constraint(equalToConstant: 30),
            
            rubNumberPortfoliolabel.topAnchor.constraint(equalTo: gbpNumberPortfoliolabel.bottomAnchor, constant: 15),
            rubNumberPortfoliolabel.leadingAnchor.constraint(equalTo: self.rubPortfoliolabel.trailingAnchor, constant: 15),
            rubNumberPortfoliolabel.heightAnchor.constraint(equalToConstant: 30),
            
            rubSellbutton.topAnchor.constraint(equalTo: gbpSellbutton.bottomAnchor, constant: 15),
            rubSellbutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            rubSellbutton.widthAnchor.constraint(equalToConstant: 50),
            rubSellbutton.heightAnchor.constraint(equalToConstant: 30),
            
            rubBuybutton.topAnchor.constraint(equalTo: gbpBuybutton.bottomAnchor, constant: 15),
            rubBuybutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -90),
            rubBuybutton.widthAnchor.constraint(equalToConstant: 50),
            rubBuybutton.heightAnchor.constraint(equalToConstant: 30),
            
            usdPortfoliolabel.topAnchor.constraint(equalTo: rubPortfoliolabel.bottomAnchor, constant: 15),
            usdPortfoliolabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30),
            usdPortfoliolabel.heightAnchor.constraint(equalToConstant: 30),
            
            usdNumberPortfoliolabel.topAnchor.constraint(equalTo: rubNumberPortfoliolabel.bottomAnchor, constant: 15),
            usdNumberPortfoliolabel.leadingAnchor.constraint(equalTo: self.usdPortfoliolabel.trailingAnchor, constant: 15),
            usdNumberPortfoliolabel.heightAnchor.constraint(equalToConstant: 30),
            
            usdSellbutton.topAnchor.constraint(equalTo: rubSellbutton.bottomAnchor, constant: 15),
            usdSellbutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            usdSellbutton.widthAnchor.constraint(equalToConstant: 50),
            usdSellbutton.heightAnchor.constraint(equalToConstant: 30),
            
            usdBuybutton.topAnchor.constraint(equalTo: rubBuybutton.bottomAnchor, constant: 15),
            usdBuybutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -90),
            usdBuybutton.widthAnchor.constraint(equalToConstant: 50),
            usdBuybutton.heightAnchor.constraint(equalToConstant: 30),
            
            totalPortfolioLabel.topAnchor.constraint(equalTo: usdPortfoliolabel.bottomAnchor, constant: 15),
            totalPortfolioLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30),
            totalPortfolioLabel.heightAnchor.constraint(equalToConstant: 30),
            
            totalNumberPortfolioLabel.topAnchor.constraint(equalTo: usdNumberPortfoliolabel.bottomAnchor, constant: 15),
            totalNumberPortfolioLabel.leadingAnchor.constraint(equalTo: totalPortfolioLabel.trailingAnchor, constant: 15),
            totalNumberPortfolioLabel.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }

    
}



