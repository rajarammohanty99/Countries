//
//  CoreDataHandler.swift
//  Countries
//
//  Created by Rajaram Mohanty on 30/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataRequest {
    
    static let coreDataRequestShareInstant = CoreDataRequest()
    
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    func addData(countriesData:CountriesModel, completion: FuncHouse.boolAction?) {
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CountriesT", in: context)
        let newCountry = NSManagedObject(entity: entity!, insertInto: context)
        
        if  let country_nameStr = countriesData.country {
            newCountry.setValue(country_nameStr, forKey: "country")
        }
        
        if  let capitalStr = countriesData.capital {
            newCountry.setValue(capitalStr, forKey: "capital")
        }
        
        if  let regionStr = countriesData.region {
            newCountry.setValue(regionStr, forKey: "region")
        }
        
        if  let sub_regionStr = countriesData.sub_region {
            newCountry.setValue(sub_regionStr, forKey: "sub_region")
        }
        
        if  let currency = countriesData.currencies[0]?.c_name {
            newCountry.setValue(currency, forKey: "currencies")
        }
        
        if  let callingcode = countriesData.callingcode?[0] {
            newCountry.setValue(callingcode, forKey: "callingcode")
        }
        
        if  let languages = countriesData.languages[0]?.name {
            newCountry.setValue(languages, forKey: "languages")
        }
        
        if  let time_zone = countriesData.time_zone?[0] {
            newCountry.setValue(time_zone, forKey: "time_zone")
        }
        
        do {
            try context.save()
            completion?(true);
        } catch {
            print("Failed saving")
            completion?(false);
        }
    }
    
    func fechAllCountries() -> String {
        var allCountries = [[String:Any]]()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountriesT")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let countryDic:[String:Any] = self.getcountryDic(countryMObject: data)
                allCountries.append(countryDic)
            }
            return json(from: allCountries)!
        } catch {
            print("Failed")
        }
        return "[]"
    }
    
    func fetchRequest(value:String) -> String {
        let context = appDelegate.persistentContainer.viewContext
        var searchResultArry = [[String:Any]]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountriesT")
        request.predicate = NSPredicate(format: "country BEGINSWITH[cd] %@", value)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let countryDic:[String:Any] = self.getcountryDic(countryMObject: data)
                searchResultArry.append(countryDic)
            }
            return json(from: searchResultArry)!
        } catch {
            print("Failed")
        }
        
        return "[]"
    }
    
    private func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    private func getcountryDic(countryMObject:NSManagedObject) -> [String:Any]{
        var countryDic = [String:Any]()
        countryDic["timezones"] = [countryMObject.value(forKey: "time_zone") as? String]
        countryDic["languages"] = [["name":countryMObject.value(forKey: "languages") as? String]]
        countryDic["callingCodes"] = [countryMObject.value(forKey: "callingcode") as? String]
        countryDic["currencies"] = [["name":countryMObject.value(forKey: "currencies") as? String]]
        countryDic["subregion"] = countryMObject.value(forKey: "sub_region") as? String
        countryDic["region"] = countryMObject.value(forKey: "region") as? String
        countryDic["capital"] = countryMObject.value(forKey: "capital") as? String
        countryDic["name"] = countryMObject.value(forKey: "country") as? String
        return countryDic
    }

}
