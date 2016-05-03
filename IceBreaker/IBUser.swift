//
//  IBUser.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 5/2/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import CoreData
import Foundation
import MultipeerConnectivity

protocol User
{
    var username: String {get}
    var animalIcon: String {get}
    var backgroundColor: String {get}
    var peerID: MCPeerID {get}
}

class IBUser: NSManagedObject, NSCoding, User
{
    @NSManaged dynamic var username: String
    @NSManaged dynamic var animalIcon: String
    @NSManaged dynamic var backgroundColor: String
    var peerID: MCPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        super.init(entity: NSEntityDescription.entityForName("IBUser", inManagedObjectContext: appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext)
    }
    
    convenience init(username: String, animalIcon: String, backgroundColor:String, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?)
    {
        self.init(entity: entity, insertIntoManagedObjectContext: context)

        self.username = username
        self.animalIcon = animalIcon
        self.backgroundColor = backgroundColor
        self.peerID = MCPeerID(displayName: self.username)
    }
    
    /*
    convenience init(username: String, animalIcon: String, backgroundColor:String, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!)
    {
        self.init(username: username, animalIcon: animalIcon, backgroundColor: backgroundColor, entity: entity, insertIntoManagedObjectContext: context)
        self.username = username
        self.animalIcon = animalIcon
        self.backgroundColor = backgroundColor
        self.peerID = MCPeerID(displayName: username)
    }
    */
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        //super.init(entity: NSEntityDescription.entityForName("IBUser", inManagedObjectContext: appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext)
        
        self.init(entity: NSEntityDescription.entityForName("IBUser", inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
        self.username = aDecoder.decodeObjectForKey("username") as! String
        self.animalIcon = aDecoder.decodeObjectForKey("animalIcon") as! String
        self.backgroundColor = aDecoder.decodeObjectForKey("backgroundColor") as! String
        self.peerID = MCPeerID(displayName: self.username)
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.username, forKey: "username")
        aCoder.encodeObject(self.animalIcon, forKey: "animalIcon")
        aCoder.encodeObject(self.backgroundColor, forKey: "backgroundColor")
    }
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, username: String, animalIcon: String, backgroundColor:String) -> IBUser
    {
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("IBUser", inManagedObjectContext: moc) as! IBUser
        newUser.username = username
        newUser.animalIcon = animalIcon
        newUser.backgroundColor = backgroundColor
        newUser.peerID = MCPeerID(displayName: newUser.username)
        return newUser
    }
}



