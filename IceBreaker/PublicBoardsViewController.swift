//
//  ViewController.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 4/18/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PublicBoardsViewController: UITableViewController
{
    let aPublicBoards = ["Politics", "Sports", "Marquette Events"]
    
    var selectedPublicBoard: IBPacketType!

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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return aPublicBoards.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = aPublicBoards[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.setSelected(false, animated: false)
        
        switch cell.textLabel!.text!
        {
        case "Politics":
            selectedPublicBoard = IBPacketType.Politics
        case "Sports":
            selectedPublicBoard = IBPacketType.Sports
        case "Marquette Events":
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
    }
}

