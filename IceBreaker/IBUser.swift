//
//  IBUser.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 5/2/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class IBUser: NSObject, NSCoding
{
    let peerID: MCPeerID
    let animalIcon: String
    let backgroundColor: String
    
    init(peerID: MCPeerID, animalIcon: String, backgroundColor:String)
    {
        self.peerID = peerID
        self.animalIcon = animalIcon
        self.backgroundColor = backgroundColor
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.peerID = aDecoder.decodeObjectForKey("peerID") as! MCPeerID
        self.animalIcon = aDecoder.decodeObjectForKey("animalIcon") as! String
        self.backgroundColor = aDecoder.decodeObjectForKey("backgroundColor") as! String
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.peerID, forKey: "peerID")
        aCoder.encodeObject(self.animalIcon, forKey: "animalIcon")
        aCoder.encodeObject(self.backgroundColor, forKey: "backgroundColor")
    }
}
