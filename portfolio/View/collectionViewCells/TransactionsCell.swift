//
//  TransactionsCell.swift
//  portfolio
//
//  Created by Tunay Toksöz on 5.04.2023.
//

import UIKit

class TransactionsCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = "TransactionsCell"
    
    private let namelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Name"
        return label
    }()
    
    private let valuelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Value"
        return label
    }()
    
    private let totalValuelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Total Value"
        return label
    }()
    
    private let tlValuelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.text = "TL Value"
        return label
    }()
    
    private let currencylabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.text = "Currency"
        return label
    }()

    
    private let datelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.text = "Date"
        return label
    }()
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupUI()
       }
           
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
    func configure(portfolio : portfolio) {
        let df = DateFormatter()
        df.dateFormat = "d MMM yyyy HH:mm:ss"
        
        let tl = portfolio.value * (portfolio.currency ?? 0)
        
        namelabel.text = portfolio.name
        datelabel.text = df.string(from: portfolio.createdTime ?? Date())
        valuelabel.text = String(format: "%.2f" , portfolio.value)
        totalValuelabel.text = String(format: "%.2f" , portfolio.totalValue ?? 0)
        tlValuelabel.text = String(format: "%.2f ₺" , tl)
        currencylabel.text = String(format: "%.2f", portfolio.currency ??  "unknown")
        if portfolio.value < 0 {
            backgroundColor = .systemRed
        } else {
            backgroundColor = .systemGreen
        }
       }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(namelabel)
        self.addSubview(datelabel)
        self.addSubview(valuelabel)
        self.addSubview(totalValuelabel)
        self.addSubview(currencylabel)
        self.addSubview(tlValuelabel)
       
        layer.cornerRadius = 8
        clipsToBounds = true
        
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        datelabel.translatesAutoresizingMaskIntoConstraints = false
        valuelabel.translatesAutoresizingMaskIntoConstraints = false
        totalValuelabel.translatesAutoresizingMaskIntoConstraints = false
        currencylabel.translatesAutoresizingMaskIntoConstraints = false
        tlValuelabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            namelabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            namelabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            
            currencylabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            currencylabel.topAnchor.constraint(equalTo: namelabel.bottomAnchor),
            
            valuelabel.leftAnchor.constraint(equalTo: namelabel.rightAnchor, constant: 15),
            valuelabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            
            tlValuelabel.leftAnchor.constraint(equalTo: valuelabel.leftAnchor),
            tlValuelabel.topAnchor.constraint(equalTo: valuelabel.bottomAnchor),
            
            totalValuelabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            totalValuelabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            
            datelabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            datelabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10)

            
        ])
    }

    
}
