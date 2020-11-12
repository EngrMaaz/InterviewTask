//
//  DataBaseHelper.swift
//  Saving Image in Core Data
//
//  Created by Nabeel on 11/03/2020.
//  Copyright © 2019 Amit Rai. All rights reserved.
//

import UIKit
import CoreData

class DataBaseHelper {
    
    static let shared = DataBaseHelper()
    
    private init() {}
    
    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    func convertDataToObject<T: Decodable>(jsonData: Data?, completion: @escaping (T?) -> ()) {
        do {
            //here dataResponse received from a network request
            let decoder = JSONDecoder()
            
            let genericObject = try decoder.decode(T.self, from: jsonData!)
            completion(genericObject)
        } catch let parsingError {
            print("Error", parsingError)
            completion(nil)
        }
    }

    func convertObjectToData<T: Encodable>(object: T) -> Data? {
        let encoder = JSONEncoder()
        do {
            return try? encoder.encode(object)
        }
    }
    
    func toLocation(contractData: NSManagedObject) -> DataModel {
        var location = DataModel()
        
        
        
        if let lat = contractData.value(forKey: "lat") as? Double {
            location.lat = lat
        }
        
        if let lon = contractData.value(forKey: "lon") as? Double {
            location.lon = lon
        }
        
        if let city = contractData.value(forKey: "city") as? String {
            location.city = city
        }
        
        if let state = contractData.value(forKey: "state") as? String {
            location.state = state
        }
        
        
        
        return location
    }
    
}
