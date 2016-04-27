//
//  IBConversation.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 4/27/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class IBConversation: NSObject
{
    private var messages: [IBPacket]
    var Messages: [IBPacket]
    {
        get
        {
            return messages
        }
    }
    
    private var people: [MCPeerID]
    var People: [MCPeerID]
    {
        get
        {
            return people
        }
    }
    
    let topic: IBPacketType
    
    init(topic: IBPacketType)
    {
        self.messages = [IBPacket]()
        self.people = [MCPeerID]()
        self.topic = topic
    }
    
    func addNewMessage(newMessage: IBPacket)
    {
        messages.append(newMessage)
        
        if (!people.contains(newMessage.sender))
        {
            people.append(newMessage.sender)
        }
    }
}