//
//  CoreDataManager.swift
//
//  Created by Nabeel on 11/03/2020.
//

import Foundation
import CoreData
import UIKit

enum Result {
   case success
   case failure
}

class CoreDataManager {
    
    //1
    static let sharedManager = CoreDataManager()
    private init() {} // Prevent clients from creating another instance.
    
    //2
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataBase")
        container.persistentStoreDescriptions.forEach { (store) in
            store.shouldMigrateStoreAutomatically = true
            store.shouldInferMappingModelAutomatically = true
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //3
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /*Insert*/
    func insertValue(entityName: String, params: NSDictionary, completion: @escaping (Result) -> ()) {
        
        /*1.
         Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
         Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
         Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
         */
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*
         An NSEntityDescription object is associated with a specific class instance
         Class
         NSEntityDescription
         A description of an entity in Core Data.
         
         Retrieving an Entity with a Given Name here person
         */
        let entity = NSEntityDescription.entity(forEntityName: entityName,
                                                in: managedContext)!
        
        
        /*
         Initializes a managed object and inserts it into the specified managed object context.
         
         init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?)
         */
        let customObject = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        /*
         With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
         */
        
        for (key,value) in params {
            customObject.setValue(value, forKey: "\(key)")
        }
        
        /*
         You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
         */
        do {
            try managedContext.save()
            completion(.success)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(.failure)
        }
    }
    
    func update(entityName: String, params: NSDictionary, objectById: String, completion: @escaping (Result,NSManagedObject?) -> ()) {
        
        /*1.
         Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
         Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
         Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
         */
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", objectById)
        
        do {
            /*
             With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
             */
            let fetchObjects = try context.fetch(fetchRequest)
            
            if fetchObjects.count > 0 {
                if let objectUpdate = fetchObjects[0] as? NSManagedObject {
                    for (key,value) in params {
                        objectUpdate.setValue(value, forKey: "\(key)")
                    }
                }
            } else {
                print("Couldn't update data")
                completion(.failure, nil)
            }
            
            
            do {
                try context.save()
                print("saved!")
                completion(.success,fetchObjects.first as? NSManagedObject)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                completion(.failure, nil)
            }
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func findById(entityName: String, predicateParams: NSDictionary) -> NSManagedObject? {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        
        for (key,value) in predicateParams {
            fetchRequest.predicate = NSPredicate(format: "\(key) = %@", "\(value)")
        }
        
        do {
            
            let fetchObject = try context.fetch(fetchRequest)
            
            if fetchObject.count > 0 {
                if let object = fetchObject[0] as? NSManagedObject {
                    return object
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } catch {
            print("Error with request: \(error)")
            return nil
        }
    }
    
    /*delete*/
    func delete(customObject : NSManagedObject, completion: ((Result) -> ())? = nil){
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        do {
            managedContext.delete(customObject)
        }
        
        do {
            try managedContext.save()
            if let completion = completion {
                completion(.success)
            }
        } catch {
            // Do something in response to error condition
            if let completion = completion {
                completion(.failure)
            }
        }
    }
    
    func fetchAllValues(entity: String) -> [NSManagedObject]? {
        
        
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
         */
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        
        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func deleteAllValues(entity: String) {
        if entityExists(name: entity) {
            let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
            
            do {
                            
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                    
                }
            } catch let error as NSError {
                print("Detele all my data in \(entity) error : \(error) \(error.userInfo)")
            }
        } else {
            print("Entity doesn't exist")
        }
    }
    
    
    func entityExists(name: String) -> Bool {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        fetchRequest.includesSubentities = false

        var entitiesCount = 0

        do {
            entitiesCount = try managedContext.count(for: fetchRequest)
        } catch {
            print("error executing fetch request: \(error)")
        }

        if entitiesCount == 0 {
            return false
        } else {
            return true
        }
    }
}

extension CoreDataManager {
    func saveStatesAndCities(entityName: String, locations: [DataModel], completion: @escaping (Result) -> ()) {
        let uuid = UUID().uuidString

        
        for location in locations {
            let params = ["lat": location.lat ?? 0.000, "lon": location.lon ?? 0.000, "city": location.city ?? "", "state": location.state ?? ""] as [String : Any]
            
            
            CoreDataManager.sharedManager.insertValue(entityName: entityName, params: params as NSDictionary, completion: completion)
        }
    }
    
}
