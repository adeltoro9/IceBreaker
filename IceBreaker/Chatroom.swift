//
//  ChatroomMenu.swift
//  Chat
//
//  Created by Ryan Walsh on 4/30/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class Chatroom: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let names: [String] = ["BigBob25", "StaceyKL_<3", "HiImGeorge16", "GoldenEagle4EVA", "PackersFan2011", "BigBob25", "GoldenEagle4EVA",]
    let messages: [String] = ["Hey everyone what's up!?", "Hey Bob, it's been a while how's it going?", "Hi guys George IS IN HOUSE! Whazzzup Stacey and Bob?", "I hope there's room for one more in this chat??", "Make that 2! GO PACK GO!!", "Haha it's great to have everyone on here together I love IceBreaker!", "Yeah and the coolest part is I'm doing all this communicating over Bluetooth!"]
    let animals: [String] = ["Alligator", "Bat", "Beaver", "Crab", "Dragon", "Alligator", "Crab"]
    let colors: [String] = ["red", "purple", "green", "blue", "orange", "red", "blue"]
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animals.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MessageCell = self.tableView.dequeueReusableCellWithIdentifier("messageCell") as! MessageCell
        
        //cell.myView.backgroundColor = self.colors[indexPath.row]
        //cell.chatroomLabel.text = self.animals[indexPath.row]
        //cell.lbUserName.text = names[indexPath.row]
        cell.txvwMessageText.text = names[indexPath.row] + ": " + messages[indexPath.row]
        cell.imgUserLogo.image = UIImage(named: animals[indexPath.row])!
        cell.imgBackgroundColor.image = UIImage(named: colors[indexPath.row])!
        
        cell.layer.borderWidth = 2.0;
        cell.layer.borderColor = UIColor.init(colorLiteralRed: 0.882, green: 0.882, blue: 0.882, alpha: 1.0).CGColor
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        let nextVC: Chatroom = segue.destinationViewController as! Chatroom
    //        nextVC. = segue.identifier!
    //    }
    
}
