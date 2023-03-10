//
//  AlertManager.swift
//  portfolio
//
//  Created by Tunay Toksöz on 6.03.2023.
//

import Foundation
import UIKit

class AlertManager {
    
    
    private func showBasicAlert(on vc: UIViewController,with title: String, message: String?, prefer : UIAlertController.Style ){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: prefer)
            alert.addAction(UIAlertAction(title: "Tamam.", style: .default))
            vc.present(alert, animated: true)
        }
    }
}

extension AlertManager {
    
    public func showBasicAlert(on vc: UIViewController, title : String, message : String, prefer : UIAlertController.Style){
        self.showBasicAlert(on: vc, with: title, message: message, prefer: prefer)
    }
    
    func showInputAlert(on vc : UIViewController,
                        title:String,
                        subtitle:String,
                        actionTitle:String,
                        cancelTitle:String? = "İptal",
                        inputPlaceholder:String? = nil,
                        inputKeyboardType:UIKeyboardType = UIKeyboardType.decimalPad,
                        cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                        actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        vc.present(alert, animated: true)
        
    }
    
    func showActionSheet(on vc: UIViewController,
                        currency : [[String]],
                        cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                        actionHandler: ((_ text: String?) -> Void)? = nil)
    {
            
        let currencies : [String] = currency.flatMap { $0 }
        
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
            for cur in currencies {
                alertController.addAction(UIAlertAction(title: cur, style: .default, handler: { (action : UIAlertAction) in
                    actionHandler?(cur)
                }))
            }
            alertController.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
            vc.present(alertController, animated: true)
    }
}
