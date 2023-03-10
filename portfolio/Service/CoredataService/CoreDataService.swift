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
    func savePortfolio(portfolio : portfolio, completion: @escaping (Result<Bool,Error>) -> Void)
    func getPortfolio(completion:  @escaping (Result<[portfolio],Error>) -> Void)
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
         

    func savePortfolio(portfolio : portfolio, completion: @escaping (Result<Bool,Error>) -> Void){
        
        let context = appDelegate.persistentContainer.viewContext
        
        let port = Portfolio(context: context)
        port.name = portfolio.name
        port.value = portfolio.value
        port.createdTime = Date()
        port.createdTimeStr = getDate()
    
        
        do {
            try context.save()
            completion(.success(true))
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    
    func getPortfolio(completion:  @escaping (Result<[portfolio],Error>) -> Void){
        
        let context = appDelegate.persistentContainer.viewContext
          
        let fetchRequest : NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        
        var portArray : [portfolio] = [portfolio]()
        
        var nameTotals : [String : Double] = [:]
        
        do {
            let portfolios = try context.fetch(fetchRequest)
            
            for port in portfolios {
                if let name = port.name, let amount = port.value as? Double {
                           if let currentTotal = nameTotals[name] {
                               nameTotals[name] = currentTotal + amount
                           } else {
                               nameTotals[name] = amount
                           }
                       }
            }
            
            for (name, total) in nameTotals {
                portArray.append(portfolio(name: name, value: total))
            }
            
            completion(.success(portArray))
            
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
        
        /**
         fetchRequest.predicate = NSPredicate(
             format: "eur LIKE %@", "\(Double(1))"
         )

         */
        
    }
    
    
}
