//
//  ChartCell.swift
//  portfolio
//
//  Created by Tunay Toksöz on 7.03.2023.
//

import UIKit
import Charts

class ChartCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "ChartCell"
    
       
       override init(frame: CGRect) {
           super.init(frame: frame)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
    func configure(view : UIView) {
        // Burayı Sor Nasıl Daha temiz yazılır?
        view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        view.subviews.last?.frame = view.frame
        addSubview(view)
        backgroundColor = .secondarySystemFill
       }
}
