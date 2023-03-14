//
//  PortfolioCell.swift
//  portfolio
//
//  Created by Tunay Toksöz on 7.03.2023.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
}

class PortfolioCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseIdentifier = "PortfolioCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private let Namelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Name"
        return label
    }()
    
    private let PriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.text = "Price"
        return label
    }()
    
    private let PriceTLlabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.text = "Price ₺"
        return label
    }()
    
    func setupUI(){
        
        backgroundColor = .tertiaryLabel
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(Namelabel)
        addSubview(PriceLabel)
        addSubview(PriceTLlabel)
        
        Namelabel.translatesAutoresizingMaskIntoConstraints = false
        PriceLabel.translatesAutoresizingMaskIntoConstraints = false
        PriceTLlabel.translatesAutoresizingMaskIntoConstraints = false
               
               
               NSLayoutConstraint.activate([
                    Namelabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    Namelabel.bottomAnchor.constraint(equalTo: PriceLabel.topAnchor,constant: -10),
                    
                    PriceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    PriceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                    
                    PriceTLlabel.topAnchor.constraint(equalTo: PriceLabel.bottomAnchor,constant: 10),
                    PriceTLlabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    
                    
                    
               ])
        
    }
    
    public func configure(collectionPortfolio : collectionPortfolio){
        DispatchQueue.main.async {
            self.Namelabel.text! = collectionPortfolio.name
            self.PriceLabel.text! = String(format: "%.2f", collectionPortfolio.price)
            self.PriceTLlabel.text! = String(format: "%.2f ₺", collectionPortfolio.priceTL)
        }
    }
}
