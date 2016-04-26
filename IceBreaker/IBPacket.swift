//
//  IBMessage.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 4/23/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum IBPacketType : Int
{
    case Private = 0
    case PingQuery = 1
    case PingResponse = 2
    case Politics = 3
    case Sports = 4
    case MUEvents = 5
    case UserData = 6
}

class IBPacket: NSObject, NSCoding
{
    let sender: MCPeerID
    let recipient: MCPeerID?    // nil if message is intended for a chat room
    let type: IBPacketType      // nil if private message between 2 users
    let message: String
    let timeStamp: NSDate
    let lifeTime: Int
    let uniqueID: NSUUID
    
    init(sender: MCPeerID, recipient: MCPeerID?, type: IBPacketType, message: String, timeStamp: NSDate, lifeTime: Int)
    {
        self.sender = sender
        
        if let rec = recipient
        {
            self.recipient = rec
        }
        else
        {
            self.recipient = nil
        }
        
        self.type = type
        self.message = message
        self.timeStamp = timeStamp
        self.lifeTime = lifeTime
        
        self.uniqueID = NSUUID()
        print(uniqueID)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.sender = aDecoder.decodeObjectForKey("sender") as! MCPeerID
        
        if let rec = (aDecoder.decodeObjectForKey("recipient") as? MCPeerID)
        {
            self.recipient = rec
        }
        else
        {
            self.recipient = nil
        }
        
        let rawValue: Int = (aDecoder.decodeObjectForKey("type") as! Int)
        self.type = IBPacketType(rawValue: rawValue)!
        self.message = aDecoder.decodeObjectForKey("message") as! String
        self.timeStamp = aDecoder.decodeObjectForKey("timeStamp") as! NSDate
        self.lifeTime = aDecoder.decodeObjectForKey("lifeTime") as! Int
        self.uniqueID = aDecoder.decodeObjectForKey("uniqueID") as! NSUUID
        print(uniqueID)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.sender, forKey: "sender")
        aCoder.encodeObject(self.recipient, forKey: "recipient")
        aCoder.encodeObject(self.type.rawValue, forKey: "type")
        aCoder.encodeObject(self.message, forKey: "message")
        aCoder.encodeObject(self.timeStamp, forKey: "timeStamp")
        aCoder.encodeObject(self.lifeTime, forKey: "lifeTime")
        aCoder.encodeObject(self.uniqueID, forKey: "uniqueID")
    }
}









