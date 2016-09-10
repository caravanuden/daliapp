//
//  PersistenceHelper.swift
//  for demo app - basic task manager with persisting data
//  helper for TaskManager.swift; returns a list of tasks and ensures that task saving and removing occurs correctly
//
//  Created by Cara Van Uden, 06/21/16
//

import UIKit
import CoreData

class PersistenceHelper: NSObject {
    
    // create appDel and context, which is managedObjectContext for AppDel
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    var context: NSManagedObjectContext;
    
    override init() {
        context = appDel.managedObjectContext
    }
    
    // checks that TaskManager.swift can save a certain named task and updates persisting data in context
    func save(entity: String, parameters: Dictionary<String,String> ) -> Bool {
        
        // save new task to persisting context
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: context) 
        for (key, value) in parameters{
            newEntity.setValue(value, forKey: key)
        }
        
        do {
            try context.save()
            return true
        } catch _ {
            return false
        }
    }
    
    // returns an array of existing tasks; used in tempTasks in TaskManager.swift before making tasks persistent
    func list(entity: String ) -> NSArray {
        
        let request = NSFetchRequest(entityName: entity)
        request.returnsObjectsAsFaults = false;
        let results: NSArray = try! context.executeFetchRequest(request)
        return results
    }
    
    // checks that TaskManager.swift can remove a certain named task and updates persisting data in context
    func remove(entity:String, key:String, value:String) -> Bool {
        
        // fetches named task
        let request = NSFetchRequest(entityName: entity)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "\(key) = %@", value)
        let results: NSArray = try! context.executeFetchRequest(request)
        
        // if there's a result, delete that result from persisting context
        if(results.count>0) {
            
            let res = results[0] as! NSManagedObject
            context.deleteObject(res)
            do {
                try context.save()
            } catch _ {
            }
            return true
        }
        
        return false
    }
    
}