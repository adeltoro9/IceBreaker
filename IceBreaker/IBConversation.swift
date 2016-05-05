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
    
    private var recipient: IBUser?
    var Recipient: IBUser?
    {
        get
        {
            return recipient
        }
        set
        {
            recipient = newValue
        }
    }
    
    let topic: IBPacketType
    
    init(topic: IBPacketType, recipient: IBUser?)
    {
        self.messages = [IBPacket]()
        self.topic = topic
        if let rec = recipient
        {
            if self.topic == IBPacketType.Private
            {
                self.recipient = rec
            }
        }
        
    }
    
    func addNewMessage(newMessage: IBPacket)
    {
        messages.append(newMessage)
    }
}