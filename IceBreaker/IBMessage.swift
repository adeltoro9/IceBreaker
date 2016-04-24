//
//  IBMessage.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 4/23/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class IBMessage: NSObject, NSCoding
{
    let sender: MCPeerID
    let recipient: MCPeerID?    // nil if message is intended for a chat room
    let subject: String?        // nil if private message between 2 users
    let message: String
    let timeStamp: NSDate
    let lifeTime: Int
    
    init(sender: MCPeerID, recipient: MCPeerID?, subject: String?, message: String, timeStamp: NSDate, lifeTime: Int)
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
        
        if let subj = subject
        {
            self.subject = subj
        }
        else
        {
            self.subject = nil
        }
        
        self.message = message
        self.timeStamp = timeStamp
        self.lifeTime = lifeTime
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
        
        if let subj = (aDecoder.decodeObjectForKey("subject") as? String)
        {
            self.subject = subj
        }
        else
        {
            self.subject = nil
        }
        
        self.message = aDecoder.decodeObjectForKey("message") as! String
        self.timeStamp = aDecoder.decodeObjectForKey("timeStamp") as! NSDate
        self.lifeTime = aDecoder.decodeObjectForKey("lifeTime") as! Int
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.sender, forKey: "sender")
        aCoder.encodeObject(self.recipient, forKey: "recipient")
        aCoder.encodeObject(self.subject, forKey: "subject")
        aCoder.encodeObject(self.message, forKey: "message")
        aCoder.encodeObject(self.timeStamp, forKey: "timeStamp")
        aCoder.encodeObject(self.lifeTime, forKey: "lifeTime")
    }
}









