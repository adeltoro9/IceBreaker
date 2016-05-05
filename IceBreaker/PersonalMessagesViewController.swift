//
//  PersonalMessagesViewController.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 5/5/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

//import Cocoa
import UIKit
import MultipeerConnectivity

class PersonalMessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //var personalMessages = [IBPacketType.Politics, IBPacketType.Sports, IBPacketType.MUEvents]
    
    var selectedPersonalMessage: IBUser!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if (myUserProfile == nil)
        {
            performSegueWithIdentifier("showSettingsScreen", sender: self)
        }
        
        super.viewWillAppear(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (ibsm.recentUsers.count > 0)
        {
            return ibsm.recentUsers.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatRoomsCell", forIndexPath: indexPath) as! ChatRoomsCell
        
        if (ibsm.recentUsers.count > 0)
        {
            let usr = ibsm.recentUsers[indexPath.row]
            cell.chatroomLabel.text = usr.username
            cell.imageIcon.image = UIImage(named: usr.animalIcon)
            cell.imageBackground.image = UIImage(named: usr.backgroundColor)
        }
        else
        {
            cell.chatroomLabel.text = "Nobody here yet..."
            cell.imageIcon.image = UIImage(named: "29")
            cell.imageBackground.image = nil
        }
        
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = UIColor.init(colorLiteralRed: 0.882, green: 0.882, blue: 0.882, alpha: 1.0).CGColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ChatRoomsCell
        cell.setSelected(false, animated: false)
        
        if (cell.chatroomLabel.text == "Nobody here yet...")
        {
            return
        }
        else
        {
            self.selectedPersonalMessage = ibsm.recentUsers[indexPath.row]
        }
        
        self.performSegueWithIdentifier("showMessageScreen", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let conv = ibsm.privateConversations[selectedPersonalMessage]
        {
            (segue.destinationViewController as! MessagesViewController).Conversation = conv
        }
        else
        {
            ibsm.privateConversations[selectedPersonalMessage] = IBConversation(topic: .Private)
            (segue.destinationViewController as! MessagesViewController).Conversation = ibsm.privateConversations[selectedPersonalMessage]
        }
        
        (segue.destinationViewController as! MessagesViewController).nvgitmTitle.title = selectedPersonalMessage.username
    }
}
