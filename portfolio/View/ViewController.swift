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
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "EUR: "
        return label
    }()
    
    private let gbpPortfoliolabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "GBP: "
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
    
    private let usdPortfoliolabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "USD: "
        return label
    }()
    
    private let totalPortfolioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "Toplam:               ₺"
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        CoreDataService().savePortfolio(portfolio: Portfolio(eur: 6, gbp: -6, rub: 0, usd: 3)) { result in
            switch result {
            case .success(true):
                print("ok")
            case .failure(let error):
                print(error)
            case .success(false):
                print("false")
            }
        }
        cdViewModel.updateChart(pieChart: pieChart)
        currencyViewModel.getCurrencyData()
        cdViewModel.getPortfolio()
        
        setupUI()
    }
    
    // MARK: - Functions
    
    func updateCurrencyLabels(eur: Double, gbp: Double, rub: Double, usd: Double, isSucces: Bool) {
        if isSucces == true {
            DispatchQueue.main.async {
                self.eurLabel.text! += "\(eur)"
                self.gbpLabel.text! += "\(gbp)"
                self.rubLabel.text! += "\(rub)"
                self.usdLabel.text! += "\(usd)"
            }
        } else {
            DispatchQueue.main.async {
                self.errorCurrencyLabel.isHidden = false
            }
        }
    }
    
    func updatePortfolioLabels(eur: Double, gbp: Double, rub: Double, usd: Double, isSucces: Bool) {
        if isSucces == true {
            DispatchQueue.main.async {
                self.eurPortfoliolabel.text! += "   \(eur.formatted())  €"
                self.gbpPortfoliolabel.text! += "   \(gbp.formatted())  £"
                self.rubPortfoliolabel.text! += "   \(rub.formatted())  ₽"
                self.usdPortfoliolabel.text! += "   \(usd.formatted())  $"
            }
        } else {
            //
        }
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
        self.view.addSubview(gbpPortfoliolabel)
        self.view.addSubview(rubPortfoliolabel)
        self.view.addSubview(usdPortfoliolabel)
        self.view.addSubview(totalPortfolioLabel)
        self.view.addSubview(eurSellbutton)
        
        currView.translatesAutoresizingMaskIntoConstraints = false
        errorCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        eurLabel.translatesAutoresizingMaskIntoConstraints = false
        gbpLabel.translatesAutoresizingMaskIntoConstraints = false
        rubLabel.translatesAutoresizingMaskIntoConstraints = false
        usdLabel.translatesAutoresizingMaskIntoConstraints = false
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        portfolioTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        eurPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        gbpPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        rubPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        usdPortfoliolabel.translatesAutoresizingMaskIntoConstraints = false
        totalPortfolioLabel.translatesAutoresizingMaskIntoConstraints = false
        eurSellbutton.translatesAutoresizingMaskIntoConstraints = false
       
        
        
        NSLayoutConstraint.activate([
            
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
            
            pieChart.topAnchor.constraint(equalTo: currView.bottomAnchor),
            pieChart.heightAnchor.constraint(equalToConstant: 300),
            pieChart.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            pieChart.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            portfolioTitlelabel.topAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: 30),
            portfolioTitlelabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            portfolioTitlelabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            eurPortfoliolabel.topAnchor.constraint(equalTo: portfolioTitlelabel.bottomAnchor, constant: 15),
            eurPortfoliolabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30),
            eurPortfoliolabel.heightAnchor.constraint(equalToConstant: 30),
            
            eurSellbutton.topAnchor.constraint(equalTo: portfolioTitlelabel.bottomAnchor, constant: 15),
            eurSellbutton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            eurSellbutton.widthAnchor.constraint(equalToConstant: 70),
            eurSellbutton.heightAnchor.constraint(equalToConstant: 30),
            
            gbpPortfoliolabel.topAnchor.constraint(equalTo: eurPortfoliolabel.bottomAnchor, constant: 15),
            gbpPortfoliolabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30),
            
            rubPortfoliolabel.topAnchor.constraint(equalTo: gbpPortfoliolabel.bottomAnchor, constant: 15),
            rubPortfoliolabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30),
            
            usdPortfoliolabel.topAnchor.constraint(equalTo: rubPortfoliolabel.bottomAnchor, constant: 15),
            usdPortfoliolabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30),
            
            totalPortfolioLabel.topAnchor.constraint(equalTo: usdPortfoliolabel.bottomAnchor, constant: 15),
            totalPortfolioLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30),
            
        ])
    }

    
}

