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
                let item = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
               
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitems: [item])
               
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .continuous
                return section
            case 1 :
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                
                section.orthogonalScrollingBehavior = .groupPagingCentered
                
                return section
            case 2:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(150)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            default:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 15, bottom: 2, trailing: 15)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                
                return section
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    // MARK: - CollectionView Configure
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
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

}
