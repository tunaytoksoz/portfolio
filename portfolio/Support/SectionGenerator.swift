//
//  SectionGenerator.swift
//  portfolio
//
//  Created by Tunay Toksöz on 8.04.2023.
//

import Foundation
import UIKit


class SectionGenerator {
    static let shared = SectionGenerator()
    func createCurrencySection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
       
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitems: [item])
       
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    func createChartsSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return section
    }
    func createPortfolioSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(150)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 15, bottom: 15, trailing: 15)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), subitems: [item])
       
        let section = NSCollectionLayoutSection(group: group)
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(50))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size,
                                                                         elementKind: "header",
                                                                         alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    func createTransactionsSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 15, bottom: 2, trailing: 15)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(50))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size,
                                                                         elementKind: "header",
                                                                         alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
}
