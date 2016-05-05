//
//  ViewController.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 4/18/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PublicBoardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let publicBoards = [IBPacketType.Politics, IBPacketType.Sports, IBPacketType.MUEvents]
    
    var selectedPublicBoard: IBPacketType!
    
    let publicBoardIcons: [IBPacketType: String] =
        [ IBPacketType.Politics:"Globe",
        IBPacketType.Sports:"Football",
        IBPacketType.MUEvents:"Classroom" ]
    let publicBoardBackgrounds: [IBPacketType: String] =
        [ IBPacketType.Politics:"orange",
        IBPacketType.Sports:"green",
        IBPacketType.MUEvents:"blue" ]

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
        return publicBoards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatRoomsCell", forIndexPath: indexPath) as! ChatRoomsCell
        
        switch publicBoards[indexPath.row]
        {
        case .Politics:
            cell.chatroomLabel.text = "Politics"
        case .Sports:
            cell.chatroomLabel.text = "Sports"
        case .MUEvents:
            cell.chatroomLabel.text = "MU Events"
        default:
            cell.chatroomLabel.text = "None"
        }
        
        cell.imageIcon.image = UIImage(named: publicBoardIcons[publicBoards[indexPath.row]]!)
        cell.imageBackground.image = UIImage(named: publicBoardBackgrounds[publicBoards[indexPath.row]]!)
        
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = UIColor.init(colorLiteralRed: 0.882, green: 0.882, blue: 0.882, alpha: 1.0).CGColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ChatRoomsCell
        cell.setSelected(false, animated: false)
        
        switch cell.chatroomLabel.text!
        {
        case "Politics":
            selectedPublicBoard = IBPacketType.Politics
        case "Sports":
            selectedPublicBoard = IBPacketType.Sports
        case "MU Events":
            selectedPublicBoard = IBPacketType.MUEvents
        default:
            selectedPublicBoard = .None
            let avc = UIAlertController(title: "Public Board Error", message: "You chosen an unrecognized public board", preferredStyle: .Alert)
            let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            avc.addAction(dismiss)
            self.presentViewController(avc, animated: true, completion: nil)
        }
        
        self.performSegueWithIdentifier("showMessageScreen", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "showMessageScreen")
        {
            if let conv = ibsm.publicConversations[selectedPublicBoard]
            {
                (segue.destinationViewController as! MessagesViewController).Conversation = conv
            }
            else
            {
                ibsm.publicConversations[selectedPublicBoard] = IBConversation(topic: selectedPublicBoard)
                (segue.destinationViewController as! MessagesViewController).Conversation = ibsm.publicConversations[selectedPublicBoard]
            }
        }
        else if (segue.identifier == "showSettingsScreen")
        {
            (segue.destinationViewController as! SettingsViewController).bPresentedAsPopover = true
        }
    }
}

