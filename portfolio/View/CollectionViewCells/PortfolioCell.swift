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
    
    private let namelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Name"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.text = "Price"
        return label
    }()
    
    private let priceTLlabel: UILabel = {
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
        
        addSubview(namelabel)
        addSubview(priceLabel)
        addSubview(priceTLlabel)
        
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceTLlabel.translatesAutoresizingMaskIntoConstraints = false
               
               
               NSLayoutConstraint.activate([
                    namelabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    namelabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor,constant: -10),
                    
                    priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                    
                    priceTLlabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,constant: 10),
                    priceTLlabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    
                    
                    
               ])
        
    }
    
    public func configure(collectionPortfolio : collectionPortfolio){
        DispatchQueue.main.async {
            self.namelabel.text! = collectionPortfolio.name
            self.priceLabel.text! = String(format: "%.2f", collectionPortfolio.price)
            self.priceTLlabel.text! = String(format: "%.2f ₺", collectionPortfolio.priceTL)
        }
    }
}
