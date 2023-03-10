//
//  CurrencyCell.swift
//  portfolio
//
//  Created by Tunay Toksöz on 9.03.2023.
//

import UIKit

class CurrencyCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "CurrencyCell"
    
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
    
    private let eurLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "EUR: "
        return label
    }()
    
    private let gbpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "GBP: "
        return label
    }()
    
    private let rubLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "RUB: "
        return label
    }()
    
    private let usdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "USD: "
        return label
    }()
    
    private let activityIndicator : UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        return ai
    }()
   
    
    func setupUI(){
        
        backgroundColor = .darkGray
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(eurLabel)
        addSubview(gbpLabel)
        addSubview(rubLabel)
        addSubview(usdLabel)
        addSubview(activityIndicator)
        
        eurLabel.translatesAutoresizingMaskIntoConstraints = false
        gbpLabel.translatesAutoresizingMaskIntoConstraints = false
        rubLabel.translatesAutoresizingMaskIntoConstraints = false
        usdLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eurLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            eurLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            
            gbpLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            gbpLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            rubLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            rubLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            
            usdLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            usdLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
        ])
    }
    
    public func configure(key : [String], value : [Double], isSucces: Bool){
        DispatchQueue.main.async { [self] in
            if isSucces {
                self.activityIndicator.stopAnimating()
                self.eurLabel.text! = String(format: "\(key[0]): %.3f",  1 / value[0])
                self.gbpLabel.text! = String(format: "\(key[1]): %.3f",  1 / value[1])
                self.rubLabel.text! = String(format: "\(key[2]): %.3f",  1 / value[2])
                self.usdLabel.text! = String(format: "\(key[3]): %.3f",  1 / value[3])
            } else {
                self.activityIndicator.center = center
                self.activityIndicator.tintColor = .link
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    
    
    
}
