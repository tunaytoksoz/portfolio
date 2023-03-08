//
//  coreDataService.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataServiceProtocol {
    func savePortfolio(portfolio : Portfolio, completion: @escaping (Result<Bool,Error>) -> Void)
    func getPortfolio(completion:  @escaping (Result<Portfolio,Error>) -> Void)
}

class CoreDataService : CoreDataServiceProtocol {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    

    func getDate() -> String{
             
             let dateFormatterGet = DateFormatter()
             dateFormatterGet.dateFormat = "MM/dd/yyyy"

             let dateFormatterPrint = DateFormatter()
             dateFormatterPrint.dateFormat = "yyyy-MM-dd"

             var now = Date().formatted(date: .numeric, time: .omitted)
             
             if let date = dateFormatterGet.date(from: "\(now)") {
                 now = dateFormatterPrint.string(from: date)
             } else {
                print("There was an error decoding the string")
             }
             
             return now
    }
         

    func savePortfolio(portfolio : Portfolio, completion: @escaping (Result<Bool,Error>) -> Void){
        
        let context = appDelegate.persistentContainer.viewContext
        
        let curr = Currencies(context: context)
        curr.eur = portfolio.eur
        curr.gbp = portfolio.gbp
        curr.rub = portfolio.rub
        curr.usd = portfolio.usd
        curr.createdTimeString = getDate()
        curr.createdTime = Date()
        
        do {
            try context.save()
            completion(.success(true))
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    
    func getPortfolio(completion:  @escaping (Result<Portfolio,Error>) -> Void){
        
        let context = appDelegate.persistentContainer.viewContext
          
        let fetchRequest : NSFetchRequest<Currencies> = Currencies.fetchRequest()
        
        /**
         fetchRequest.predicate = NSPredicate(
             format: "eur LIKE %@", "\(Double(1))"
         )
         
         */
        var port = Portfolio(eur: 0, gbp: 0, rub: 0, usd: 0)
        
        do {
            let currencies = try context.fetch(fetchRequest )
            
            for curr in currencies {
                port.eur += curr.eur
                port.gbp += curr.gbp
                port.rub += curr.rub
                port.usd += curr.usd
                // port.createdTime = currencies.last?.createdTime
            }
            
            completion(.success(port))
            
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    
}
