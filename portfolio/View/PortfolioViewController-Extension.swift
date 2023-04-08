//
//  ExtensionViewController.swift
//  portfolio
//
//  Created by Tunay Toksöz on 16.03.2023.
//

import UIKit

extension PortfolioViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            switch sectionIndex {
            case 0:
                return SectionGenerator.shared.createCurrencySection()
            case 1 :
                return SectionGenerator.shared.createChartsSection()
            case 2:
                return SectionGenerator.shared.createPortfolioSection()
            default:
                return SectionGenerator.shared.createTransactionsSection()
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
    // MARK: - CollectionView Configure
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return keys.count
        case 1:
            return chartArray.count
        case 2:
            return portfolioArray.count
        case 3:
            return transactions.count
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        if indexPath.section == 2 {
            sectionHeader.title.text = "Portföyüm"
            sectionHeader.subtitle.text = ""
        }
        else {
            sectionHeader.title.text = "Geçmiş İşlemler"
            sectionHeader.subtitle.text = ""
        }
        return sectionHeader
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.reuseIdentifier, for: indexPath) as? CurrencyCell else {
                return UICollectionViewCell()
            }
            
            if keys.first?.count == 0 {
                cell.configure(key: keys[indexPath.item], value: values[indexPath.item], isSucces: false)
            } else {
                cell.configure(key: keys[indexPath.item], value: values[indexPath.item], isSucces: true)
            }
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCell.reuseIdentifier, for: indexPath) as? ChartCell else {
                return UICollectionViewCell()
            }
            cell.configure(view: chartArray[indexPath.item])
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioCell.reuseIdentifier, for: indexPath) as? PortfolioCell else {
                return UICollectionViewCell()
            }
                cell.configure(collectionPortfolio: portfolioArray[indexPath.item])
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionsCell.reuseIdentifier, for: indexPath) as? TransactionsCell else {
                return UICollectionViewCell()
            }
            cell.configure(portfolio: transactions[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            let name = portfolioArray[indexPath.item].name
            let price = portfolioArray[indexPath.item].price
            
            AlertManager().showInputAlert(on: self, title: "\(name) Sat", subtitle: "Lütfen Miktar Girin", actionTitle: "Sat", actionHandler:  { text in
                if let text = text {
                    guard let text = Double(text) else { return AlertManager().showBasicAlert(on: self, title: "Error", message: "error", prefer: .alert) }
                    if text <= price {
                        let succes = self.portfolioViewModel.saveTransaction(portfolio: Portfolios(name: name, value: -text), curr: self.currencies[name] ?? 1)
                        if succes {
                            AlertManager().showBasicAlert(on: self, title: "Başarılı", message: "Satıldı.", prefer: .alert)
                            self.getData()
                        }
                    } else {
                        AlertManager().showBasicAlert(on: self, title: "Başarısız", message: "Döviz Tutarını Kontrol Edin!", prefer: .alert)
                    }

                }
            })
        }
    }

}
