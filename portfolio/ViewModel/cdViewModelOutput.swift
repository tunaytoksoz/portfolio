//
//  cdViewModelOutput.swift
//  portfolio
//
//  Created by Tunay Toksöz on 1.03.2023.
//

import Foundation
import Charts
import UIKit

protocol cdViewModelOutput : AnyObject {
    func updateCharts(view : UIView, type: chartType)
}
