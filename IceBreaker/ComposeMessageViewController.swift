//
//  ComposeMessageViewController.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 5/3/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import UIKit
import CoreData
import MultipeerConnectivity

class ComposeMessageViewController: UIViewController, UITextViewDelegate
{
    private var ibc: IBConversation!
    
    var Conversation: IBConversation!
        {
        get
        {
            if let conv = ibc
            {
                return conv
            }
            
            return nil
        }
        set
        {
            ibc = newValue
        }
    }
    
    @IBOutlet weak var txvwNewMessage: UITextView!
    
    @IBAction func btnCancel_Click(sender: AnyObject)
    {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func btnSend_Click(sender: AnyObject)
    {
        if txvwNewMessage.text != ""
        {
            let ibp = IBPacket(sender: myUserProfile.getIBUserObj(), recipient: nil, type: ibc.topic, message: txvwNewMessage.text, timeStamp: NSDate(), lifeTime: DEFAULT_LIFETIME)
            
            if !ibsm.sendPacket(ibp, bPrintMessageToScreen: true)
            {
                ibp.message = "Error could not send message"
            }
            
            txvwNewMessage.text = ""
            ibc.addNewMessage(ibp)
            
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            self.view.endEditing(true)
            btnSend_Click(self)
            return false
        }
        
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        textView.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        txvwNewMessage.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        txvwNewMessage.delegate = self
        txvwNewMessage.text = ""
    }
}
