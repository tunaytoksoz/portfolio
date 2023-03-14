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
    func savePortfolio(portfolio : portfolio, curr : Double, completion: @escaping (Result<Bool,Error>) -> Void)
    func getPortfolio(completion:  @escaping (Result<[portfolio],Error>) -> Void)
    func saveDailyTable(totalValue : Double)
 //   func getPortfolioWithDayFilter(date : String ,completion:  @escaping (Result<[DailyPortfolios],Error>) -> Void)
}

class CoreDataService : CoreDataServiceProtocol {
 
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveDailyTable(totalValue : Double){
        let tz = TimeZone.current
        tz.localizedName(for: .generic, locale: .autoupdatingCurrent)
        let contex = appDelegate.persistentContainer.viewContext
        
        let today = Date().formatted(date: .numeric, time: .omitted)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let queryDate = dateFormatter.date(from: today)!
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: queryDate)
        print(startOfDay)
        let midnight = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        
        let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "day >= %@ AND day < %@", queryDate as NSDate, midnight as NSDate)
        
        do {
            let response = try contex.fetch(fetchRequest)
            if response.count > 0 {
                response.first?.totalValue = totalValue
                response.first?.day = Date()
                try contex.save()
            } else {
                let dp = DailyPortfolio(context: contex)
                dp.totalValue = totalValue
                dp.day = Date()
                try contex.save()
            }
        } catch {
            
        }
    }
    
    func savePortfolio(portfolio : portfolio, curr : Double, completion: @escaping (Result<Bool,Error>) -> Void){
        
        let context = appDelegate.persistentContainer.viewContext
        
        if let total = UserDefaults.standard.object(forKey: portfolio.name) as? Double{
            let port = Portfolio(context: context)
            port.name = portfolio.name
            port.value = portfolio.value
            port.createdTime = Date()
            port.createdTimeStr = Date().formatted(date: .numeric, time: .standard)
            port.totalValue = total + portfolio.value
        } else {
            let port = Portfolio(context: context)
            port.name = portfolio.name
            port.value = portfolio.value
            port.createdTime = Date()
            port.createdTimeStr = Date().formatted(date: .numeric, time: .standard)
            port.totalValue = portfolio.value
        }
        
        do {
            try context.save()
            completion(.success(true))
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func getPortfolio(completion:  @escaping (Result<[portfolio],Error>) -> Void){
        var portArray : [portfolio] = [portfolio]()
        var nameTotals : [String : Double] = [:]
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        
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
                UserDefaults.standard.setValue(total, forKey: name)
            }
            UserDefaults.standard.synchronize()
            
            completion(.success(portArray))
            
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
        /*
         func getPortfolioWithDayFilter(date : String ,completion:  @escaping (Result<[DailyPortfolios],Error>) -> Void){
             
             let context = appDelegate.persistentContainer.viewContext
               
             let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
             
             var portArray : [DailyPortfolios] = [DailyPortfolios]()
             
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "MM/dd/yyyy"
             let queryDate = dateFormatter.date(from: date)!
             let calendar = Calendar.current
             let startOfDay = calendar.startOfDay(for: queryDate)
             print(startOfDay)
             let midnight = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: queryDate)!
              
             let predicate = NSPredicate(format: "day >= %@ AND day < %@", queryDate as NSDate, midnight as NSDate)

             fetchRequest.predicate = predicate
             
             do {
                 let portfolios = try context.fetch(fetchRequest)
                 for port in portfolios{
                     portArray.append(DailyPortfolios(totalValue: port.totalValue, day: port.day))
                 }
                 print(portArray)
                 completion(.success(portArray))
             } catch let error as NSError {
                 completion(.failure(error))
             }
         }
         */

}
