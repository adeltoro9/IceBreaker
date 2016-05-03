//
//  MessagesViewController.swift
//  Chat
//
//  Created by Ryan Walsh on 4/30/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
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
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var nvgitmTitle: UINavigationItem!
    @IBOutlet weak var btnConnectedPeers: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (ibsm.delegate == nil)
        {
            ibsm.delegate = self
        }
        
        print("\(self.Conversation.topic)")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
        switch ibc.topic
        {
        case .Politics:
            nvgitmTitle.title = "Politics"
        case .Sports:
            nvgitmTitle.title = "Sports"
        case .MUEvents:
            nvgitmTitle.title = "MU Events"
        default:
            nvgitmTitle.title = "None"
        }
        
        refreshMessageScreen(ibsm)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        
        if (ibsm.delegate == nil)
        {
            ibsm.delegate = self
        }
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        ibsm.delegate = nil
        
        super.viewDidDisappear(true)
    }

    @IBAction func btnCompose_Click(sender: AnyObject)
    {
        self.performSegueWithIdentifier("showNewMessageScreen", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "showNewMessageScreen")
        {
            (segue.destinationViewController as! ComposeMessageViewController).Conversation = ibc
        }
    }
    
    @IBAction func btnResetConnection_Click(sender: AnyObject)
    {
        ibsm.resetConnection()
    }
    
    @IBAction func btnConnectedPeers_Click(sender: AnyObject)
    {
        var devices = ""
        
        if (ibsm.session.connectedPeers.count > 0)
        {
            for peer in ibsm.session.connectedPeers
            {
                devices += peer.displayName + "  "
            }
        }
        else
        {
            devices = "None"
        }
        
        let avc = UIAlertController(title: "Connected Devices", message: devices, preferredStyle: .ActionSheet)
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        avc.addAction(dismiss)
        
        presentViewController(avc, animated: true, completion: nil)
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (ibc.Messages.count > 0)
        {
            return self.ibc.Messages.count
        }
        else
        {
            return 1
        }
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        
        if (ibc.Messages.count > 0)
        {
            let ibp = ibc.Messages[indexPath.row]
            
            cell.txvwMessageText.text = ibp.sender.username + ": " + ibp.message
            cell.imgUserLogo.image = UIImage(named: ibp.sender.animalIcon)!
            cell.imgBackgroundColor.image = UIImage(named: ibp.sender.backgroundColor)!
        }
        else
        {
            cell.txvwMessageText.text = "IceBreaker: Break the ice!"
            cell.imgUserLogo.image = UIImage(named: "29")
            cell.imgBackgroundColor.image = nil
        }
        
        cell.layer.borderWidth = 2.0;
        cell.layer.borderColor = UIColor.init(colorLiteralRed: 0.882, green: 0.882, blue: 0.882, alpha: 1.0).CGColor
        
        return cell
    }
    
    /*
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("You tapped cell number \(indexPath.row).")
    }
    */
}

// TODO BOTH OF THESE METHODS NEED WORK
// MESSAGES DO NOT SHOW UP WHEN RECEIVED, TABLEVIEW DISAPPEARS
// CONNECTED PEERS SHOWS 0 WHEN WE HAVE 1 CONNECTION
// IBCONVERSATION CLASS CHANGES THE SENDER OF OLD MESSAGES

//# MARK: - IceBreakerServiceManagerDelegate Protocol
extension MessagesViewController: IceBreakerServiceManagerDelegate
{
    func connectedDevicesChanged(manager : IceBreakerServiceManager, connectedDevices: [String])
    {
        if NSThread.isMainThread()
        {
            self.btnConnectedPeers.title = "\(connectedDevices.count)"
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
            {
                self.btnConnectedPeers.title = "\(connectedDevices.count)"
            })
        }
        
        print("Connected devices: \(connectedDevices)")
    }
    
    func refreshMessageScreen(manager: IceBreakerServiceManager)
    {
        if NSThread.isMainThread()
        {
            var reloadIndexPaths = [NSIndexPath]()
            
            if let paths = self.tableView.indexPathsForVisibleRows
            {
                //reloadIndexPaths = paths
                self.tableView.reloadData()
            }
            else
            {
                reloadIndexPaths.append(NSIndexPath(forRow: 0, inSection: 0))
                self.tableView.reloadRowsAtIndexPaths(reloadIndexPaths, withRowAnimation: .Fade)
            }
            
            // TODO figure out how to scroll tableview to bottom without messing stuff up
            //self.tableView.reloadData()
            //self.tableView.setContentOffset(CGPointMake(0, CGFloat.max), animated: true)
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
            {
                var reloadIndexPaths = [NSIndexPath]()
                
                if let paths = self.tableView.indexPathsForVisibleRows
                {
                    //reloadIndexPaths = paths
                    self.tableView.reloadData()
                }
                else
                {
                    reloadIndexPaths.append(NSIndexPath(forRow: 0, inSection: 0))
                    self.tableView.reloadRowsAtIndexPaths(reloadIndexPaths, withRowAnimation: .Fade)
                }
            })
        }
    }
}


