//
//  CoreDataOperations.swift
//  ChatEzee
//
//  Created by Shumaz Ahamed Junaidi on 6/7/18.
//  Copyright © 2018 Shumaz Ahamed Junaidi. All rights reserved.
//

import UIKit
import CoreData
class CoreDataOperations: NSObject {
    
    private class func getContext()->  NSManagedObjectContext {
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(userID: String, imageData: NSData)->Bool{
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "ProfileImages", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(userID, forKey: "userid")
        managedObject.setValue(imageData, forKey: "imagedata")
        do{
            try context.save()
            return true
        }catch{
            return false
        }
    }
    
    
    class func returnCoreDataCacheImage(userID: String) -> NSData{
        let context = getContext()
        var resImgData: NSData? = nil
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileImages")
        //Update record based on where condition as below...
        //  fetchRequest.predicate = NSPredicate(format: "userid = %@ AND alertType = %&",argumentArray: [creationDate, alertType])
        fetchRequest.predicate = NSPredicate(format: "userid = %@",argumentArray: [userID])
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for record in results! {
                    resImgData = record.value(forKey: "imagedata") as? NSData
                    
                }
            /*    for object in results! {
                        context.delete(object)
                    }
             */
                return (resImgData)!
                // In my case, I only updated the first item in results
                ///results![0].setValue(imageData, forKey: "imagedata")
            }
        }catch {
            print("Fetch Failed: \(error)")
        }
        
        let imageData: Data = UIImagePNGRepresentation(UIImage(named: "prof")!)!
        
        return imageData as NSData
    }
    
    class func UpdateObject(userID: String, imageData: NSData)-> Bool{
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileImages")
        //Update record based on where condition as below...
      //  fetchRequest.predicate = NSPredicate(format: "userid = %@ AND alertType = %&",argumentArray: [creationDate, alertType])
        fetchRequest.predicate = NSPredicate(format: "userid = %@",argumentArray: [userID])
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                ///let res = results! as [NSManagedObject]
                
                // In my case, I only updated the first item in results
                ///results![0].setValue(imageData, forKey: "imagedata")
            }else{
                CoreDataOperations.saveObject(userID: userID, imageData: imageData)
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
       /* do{
            try context.save()
            return true
        }catch{
            return false
        }
 */
        return true
    }
}
