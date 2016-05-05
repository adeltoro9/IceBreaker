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

class IBUser: NSObject, NSCoding
{
    var uuid: NSUUID!
    var peerID: MCPeerID!
    var username: String!
    var animalIcon: String!
    var backgroundColor: String!
    
    convenience init(uuid: NSUUID, username: String, animalIcon: String, backgroundColor:String)
    {
        self.init()
        
        self.uuid = uuid
        self.username = username
        self.peerID = MCPeerID(displayName: self.username)
        self.animalIcon = animalIcon
        self.backgroundColor = backgroundColor
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        self.init()
        
        self.uuid = aDecoder.decodeObjectForKey("uuid") as! NSUUID
        self.username = aDecoder.decodeObjectForKey("username") as! String
        self.peerID = MCPeerID(displayName: self.username)
        self.animalIcon = aDecoder.decodeObjectForKey("animalIcon") as! String
        self.backgroundColor = aDecoder.decodeObjectForKey("backgroundColor") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.uuid, forKey: "uuid")
        aCoder.encodeObject(self.username, forKey: "username")
        aCoder.encodeObject(self.animalIcon, forKey: "animalIcon")
        aCoder.encodeObject(self.backgroundColor, forKey: "backgroundColor")
    }

}



