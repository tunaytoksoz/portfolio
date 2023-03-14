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
    
    private let topLeftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "EUR: "
        return label
    }()
    
    private let topRightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "GBP: "
        return label
    }()
    
    private let bottomLeft: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "RUB: "
        return label
    }()
    
    private let bottomRight: UILabel = {
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
        
        addSubview(topLeftLabel)
        addSubview(topRightLabel)
        addSubview(bottomLeft)
        addSubview(bottomRight)
        addSubview(activityIndicator)
        
        topLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        topRightLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLeft.translatesAutoresizingMaskIntoConstraints = false
        bottomRight.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topLeftLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            topLeftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            
            topRightLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            topRightLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            bottomLeft.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            bottomLeft.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            
            bottomRight.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            bottomRight.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
        ])
    }
    
    public func configure(key : [String], value : [Double], isSucces: Bool){
        DispatchQueue.main.async { [self] in
            if isSucces == true {
                self.activityIndicator.stopAnimating()
                self.topLeftLabel.text! = String(format: "\(key[0]): %.3f",  1 / value[0])
                self.topRightLabel.text! = String(format: "\(key[1]): %.3f",  1 / value[1])
                self.bottomLeft.text! = String(format: "\(key[2]): %.3f",  1 / value[2])
                self.bottomRight.text! = String(format: "\(key[3]): %.3f",  1 / value[3])
            } else {
                self.activityIndicator.center = center
                self.activityIndicator.color = .white
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    
    
    
}
