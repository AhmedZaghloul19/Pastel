//
//  CoreDataManager.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/30/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import Foundation
import CoreData
import os

public class CoreDataManager {
    private static let identifier: String  = "com.AhmedZaghloul.Pastel"       //Your framework bundle ID
    private static let model: String       = "Pastel"                      //Model name
    
    /**
     **Presistent Container for the CoreDataManager**.
     ````
     Core data
     ````
     */
    private static let persistentContainer: NSPersistentContainer = {
        let messageKitBundle = Bundle(identifier: CoreDataManager.identifier)
        let modelURL = messageKitBundle!.url(forResource: CoreDataManager.model, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        let container = NSPersistentContainer(name: CoreDataManager.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error{
                
                os_log("❌ Loading of store failed: %{PUBLIC}@", log: OSLog.default, type: .error, err.localizedDescription)
                fatalError("❌ Loading of store failed:\(err)")
            }
        }
        
        os_log("✅ Got Presistent Container succesfully", type: .debug)
        return container
    }()
    
    // MARK: Groups
    
    /**
     **save new group**.
     ````
     Core data
     ````
     - Parameter group: the object to be saved
     */
    public static func saveNew(Group group: Group){
        
        let context = CoreDataManager.persistentContainer.viewContext
        let newGroup = NSEntityDescription.insertNewObject(forEntityName: "GroupEntity", into: context) as! GroupEntity
        
        newGroup.iconfarm = Int32(group.iconfarm ?? 0)
        newGroup.iconserver = group.iconserver ?? ""
        newGroup.isEighteenPlus = group.isEighteenPlus ?? false
        newGroup.members = group.members ?? ""
        newGroup.name = group.name ?? ""
        newGroup.nsid = group.nsid ?? ""
        
        do {
            try context.save()
            os_log("✅ Group saved succesfuly", type: .debug)
        } catch let error{
            os_log("❌ Failed to create Group", log: OSLog.default, type: .error, error.localizedDescription)
            
        }
    }
    
    /**
     **Get saved local Groups**.
     ````
     Core data
     ````
     - Parameter groups: array of returned groups
     - Parameter error: error object if found
     */
    public static func fetchGroups(callback: @escaping (_ groups: [Group]?,_ error: Error?) -> ()){
        
        let context = CoreDataManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<GroupEntity>(entityName: "GroupEntity")
        
        do{
            
            let retrievedData = try context.fetch(fetchRequest)
            var groups: [Group] = []
            for group in retrievedData {
                groups.append(Group(entity: group))
            }
            callback(groups,nil)
            os_log("✅ Groups retrieved succesfully", type: .debug)
        }catch let fetchErr {
            callback(nil,fetchErr)
            os_log("❌ Failed to fetch Groups", log: OSLog.default, type: .error, fetchErr.localizedDescription)
        }
    }
    
    /**
     **delete all groups from local storage**.
     ````
     Core data
     ````
     */
    public static func deleteAllGroupsRecords() {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GroupEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            os_log("✅ Groups Deleted succesfully", type: .debug)
        } catch let error {
            os_log("❌ Failed to Delete Groups", log: OSLog.default, type: .error, error.localizedDescription)
        }
    }
    
    /**
     **Check if the local storage having groups**.
     ````
     Core data
     ````
     */
    public static func isLocalStorageHavingGroups() -> Bool {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<GroupEntity>(entityName: "GroupEntity")
        
        do{
            let retrievedData = try context.fetch(fetchRequest)
            
            os_log("✅ Groups retrieved succesfully", type: .debug)
            return retrievedData.count != 0
        }catch let error {
            os_log("❌ Failed to fetch Groups count", log: OSLog.default, type: .error, error.localizedDescription)
            return false
        }
    }
    
    /**
     **Number of saved groups**.
     ````
     Core data
     ````
     */
    public static func numberOfSavedGroups() -> Int {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<GroupEntity>(entityName: "GroupEntity")
        
        do{
            let retrievedData = try context.fetch(fetchRequest)
            
            os_log("✅ Groups retrieved succesfully", type: .debug)
            return retrievedData.count
        }catch let error {
            os_log("❌ Failed to fetch Groups count", log: OSLog.default, type: .error, error.localizedDescription)
            return 0
        }
    }
    
    // MARK: Photos
    
    /**
     **save new photo**.
     ````
     Core data
     ````
     - Parameter photo: the object to be saved
     */
    public static func saveNew(Photo photo: Photo){
        
        let context = CoreDataManager.persistentContainer.viewContext
        let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "PhotoEntity", into: context) as! PhotoEntity
        
        newPhoto.farm = Int32(photo.farm ?? 0)
        newPhoto.server = photo.server ?? ""
        newPhoto.secret = photo.secret ?? ""
        newPhoto.id = photo.id ?? ""
        
        do {
            try context.save()
            
            os_log("✅ Group Saved succesfully", type: .debug)
        } catch let error {
            os_log("❌ Failed to create Group", log: OSLog.default, type: .error, error.localizedDescription)
        }
    }
    
    /**
     **Get saved local photos**.
     ````
     Core data
     ````
     - Parameter photos: array of returned photos
     - Parameter error: error object if found
     */
    public static func fetchPhotos(callback: @escaping (_ photos: [Photo]?,_ error: Error?) -> ()){
        
        let context = CoreDataManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        
        do{
            
            let retrievedData = try context.fetch(fetchRequest)
            var photos: [Photo] = []
            for photo in retrievedData {
                photos.append(Photo(entity: photo))
            }
            callback(photos,nil)
            
            os_log("✅ Photos retrieved succesfully", type: .debug)
        }catch let fetchErr {
            callback(nil,fetchErr)
            os_log("❌ Failed to fetch Photo:", log: OSLog.default, type: .error, fetchErr.localizedDescription)
        }
    }
    
    /**
     **Delete saved photos**.
     ````
     Core data
     ````
     */
    public static func deleteAllPhotosRecords() {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            
            os_log("✅ Photos retrieved succesfully", type: .debug)
        } catch let error {
            os_log("❌ Failed to Delete Photos:", log: OSLog.default, type: .error, error.localizedDescription)
        }
    }
    
    /**
     **Checking if there's photos in the local database**.
     ````
     Core data
     ````
     */
    public static func isLocalStorageHavingPhotos() -> Bool {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        
        do{
            let retrievedData = try context.fetch(fetchRequest)
            
            os_log("✅ Photos retrieved succesfully", type: .debug)
            return retrievedData.count != 0
        }catch let error {
            os_log("❌ Failed to fetch Photos Count", log: OSLog.default, type: .error, error.localizedDescription)
            return false
        }
    }
    
    /**
     **Get number of saved photos**.
     ````
     Core data
     ````
     */
    public static func numberOfSavedPhotos() -> Int {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        
        do{
            let retrievedData = try context.fetch(fetchRequest)
            os_log("✅ Photos retrieved succesfully", type: .debug)
            return retrievedData.count
        }catch let error {
            os_log("❌ Failed to fetch Photos Count", log: OSLog.default, type: .error, error.localizedDescription)
            return 0
        }
    }
}

