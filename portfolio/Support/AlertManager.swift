//
//  AlertManager.swift
//  portfolio
//
//  Created by Tunay Toksöz on 6.03.2023.
//

import Foundation
import UIKit

class AlertManager {
    private func showBasicAlert(on vc: UIViewController,with title: String, message: String?){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam.", style: .default))
            vc.present(alert, animated: true)
        }
    }
}

extension AlertManager {
    public func showBasicAlert(on vc: UIViewController, title : String, message : String){
        self.showBasicAlert(on: vc, with: title, message: message)
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
}
