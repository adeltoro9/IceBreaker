//
//  IBUserProfile.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 5/4/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import CoreData
import Foundation
import MultipeerConnectivity

protocol User
{
    var uuid: String {get}
    var myUUID: NSUUID {get}
    var username: String {get}
    var peerID: MCPeerID {get}
    var animalIcon: String {get}
    var backgroundColor: String {get}
}

class IBUserProfile: NSManagedObject, User
{
    @NSManaged dynamic var uuid: String
    var myUUID: NSUUID = NSUUID()
    @NSManaged dynamic var username: String
    var peerID: MCPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
    @NSManaged dynamic var animalIcon: String
    @NSManaged dynamic var backgroundColor: String
    //@NSManaged dynamic var friendList: [String]
    //@NSManaged dynamic var blockList: [String]
    
    /*
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        super.init(entity: NSEntityDescription.entityForName("IBUserProfile", inManagedObjectContext: appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext)
    }
    
    
    convenience init?(uuid: String?, username: String, animalIcon: String, backgroundColor: String, friendList: [String]?, blockList: [String]?,entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?)
    {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        if let storedUUID = uuid
        {
            self.uuid = storedUUID
            
            if NSUUID(UUIDString: storedUUID) != self.myUUID
            {
                print("storedUUID: " + storedUUID)
                print("myUUID: " + self.myUUID.UUIDString)
                return nil
            }
        }
        else
        {
            self.uuid = self.myUUID.UUIDString
        }
        
        self.username = username
        self.peerID = MCPeerID(displayName: self.username)
        self.animalIcon = animalIcon
        self.backgroundColor = backgroundColor
        
        /*
        if let fl = friendList
        {
            self.friendList = fl
        }
        else
        {
            self.friendList = [String]()
        }
        
        if let bl = blockList
        {
            self.blockList = bl
        }
        else
        {
            self.blockList = [String]()
        }
        */
    }
    */
 
 
    func getIBUserObj() -> IBUser
    {
        return IBUser(uuid: self.myUUID, username: self.username, animalIcon: self.animalIcon, backgroundColor: self.backgroundColor)
    }
    
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, uuid: String?, username: String, animalIcon: String, backgroundColor: String, friendList: [String]?, blockList: [String]?) -> IBUserProfile?
    {
        let newUserProfile = NSEntityDescription.insertNewObjectForEntityForName("IBUserProfile", inManagedObjectContext: moc) as! IBUserProfile
        
        newUserProfile.myUUID = NSUUID()
        
        if let storedUUID = uuid
        {
            newUserProfile.uuid = storedUUID
            
            if NSUUID(UUIDString: storedUUID) != newUserProfile.myUUID
            {
                print("storedUUID: " + storedUUID)
                print("myUUID: " + newUserProfile.myUUID.UUIDString)
                return nil
            }
        }
        else
        {
            newUserProfile.uuid = newUserProfile.myUUID.UUIDString
        }
        
        newUserProfile.username = username
        newUserProfile.peerID = MCPeerID(displayName: newUserProfile.username)
        newUserProfile.animalIcon = animalIcon
        newUserProfile.backgroundColor = backgroundColor
        
        /*
        if let fl = friendList
        {
            newUserProfile.friendList = fl
        }
        else
        {
            newUserProfile.friendList = [String]()
        }
        
        if let bl = blockList
        {
            newUserProfile.blockList = bl
        }
        else
        {
            newUserProfile.blockList = [String]()
        }
        */
        
        return newUserProfile
    }
    
}