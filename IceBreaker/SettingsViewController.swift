//
//  SettingsViewController.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 5/2/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

//import Cocoa
import UIKit
import CoreData
import MultipeerConnectivity

class SettingsViewController: UIViewController
{
    let animals: [String] = ["Alligator", "Bat", "Bear", "Beaver", "Bee", "Bull", "Caterpillar", "Crab", "Dragon", "Goat", "Leopard", "Ox", "Pelican", "Pig", "Rat", "Tiger"]
    let backgrounds: [String] = ["red", "orange", "yellow", "green", "blue",  "purple", "pink"]
    
    var animalIndex: Int = 0
    var backgroundIndex: Int = 0
    
    var bPresentedAsPopover: Bool = false
    
    @IBOutlet weak var imgvwBackground: UIImageView!
    @IBOutlet weak var imgvwAnimalIcon: UIImageView!
    @IBOutlet weak var txfldUserInput: UITextField!
    @IBOutlet weak var lbHelpLabel: UILabel!
    
    override func viewWillAppear(animated: Bool)
    {
        if (bPresentedAsPopover)
        {
            lbHelpLabel.text = "Please create  a user profile.\n\nSwipe left/right to change colors and,\nswipe up/down to change icons."
            return
        }
        else
        {
            lbHelpLabel.text = "Swipe left/right to change colors and,\nswipe up/down to change icons."
        }
        
        txfldUserInput.text = myUserProfile.username
        animalIndex = animals.indexOf(myUserProfile.animalIcon)!
        imgvwAnimalIcon.image = UIImage(named: self.animals[self.animalIndex])
        backgroundIndex = backgrounds.indexOf(myUserProfile.backgroundColor)!
        imgvwBackground.image = UIImage(named: self.backgrounds[self.backgroundIndex])
    }
    
    @IBAction func swipeLeft(sender: AnyObject)
    {
        if (backgroundIndex != backgrounds.count - 1)
        {
            backgroundIndex += 1
        }
        else
        {
            backgroundIndex = 0
        }
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: .TransitionCrossDissolve, animations:
            {
                self.imgvwBackground.image = UIImage(named: self.backgrounds[self.backgroundIndex])
            }, completion: nil)
    }
    
    @IBAction func swipeRight(sender: AnyObject)
    {
        if (backgroundIndex != 0)
        {
            backgroundIndex -= 1
        }
        else
        {
            backgroundIndex = backgrounds.count - 1
        }
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: .TransitionCrossDissolve, animations:
            {
                self.imgvwBackground.image = UIImage(named: self.backgrounds[self.backgroundIndex])
            }, completion: nil)
    }
    
    @IBAction func swipeUp(sender: AnyObject)
    {
        if (animalIndex != animals.count - 1)
        {
            animalIndex += 1
        }
        else
        {
            animalIndex = 0
        }
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: .TransitionCrossDissolve, animations:
            {
                self.imgvwAnimalIcon.image = UIImage(named: self.animals[self.animalIndex])
            }, completion: nil)
    }
    
    @IBAction func swipeDown(sender: AnyObject)
    {
        if (animalIndex != 0)
        {
            animalIndex -= 1
        }
        else
        {
            animalIndex = animals.count - 1
        }
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: .TransitionCrossDissolve, animations:
            {
                self.imgvwAnimalIcon.image = UIImage(named: self.animals[self.animalIndex])
            }, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        txfldUserInput.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func textFieldEditingDidEnd(sender: AnyObject)
    {
        sender.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func textfieldDidEndOnExit(sender: AnyObject)
    {
        sender.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        return true
    }

    @IBAction func btnSave_TouchUpInside(sender: AnyObject)
    {
        if let newUsername = txfldUserInput.text
        {
            if newUsername.containsString(" ")
            {
                let avc = UIAlertController(title: "Invalid Username", message: "Your username cannot contain any spaces.", preferredStyle: .Alert)
                let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                avc.addAction(dismiss)
                self.presentViewController(avc, animated: true, completion: nil)
            }
            else if (newUsername != "")
            {
                do
                {
                    if (bPresentedAsPopover)
                    {
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        
                        if let userProfile = IBUserProfile.createInManagedObjectContext(appDelegate.managedObjectContext, uuid: nil, username: newUsername, animalIcon: animals[animalIndex], backgroundColor: backgrounds[backgroundIndex], friendList: nil, blockList: nil)
                            //IBUserProfile(uuid: nil, username: newUsername, animalIcon: animals[animalIndex], backgroundColor: backgrounds[backgroundIndex], friendList: nil, blockList: nil, entity: NSEntityDescription.entityForName("IBUserProfile", inManagedObjectContext: appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext)
                        {
                            myUserProfile = userProfile
                        }
                        else
                        {
                            abort()
                        }
                        try myUserProfile.managedObjectContext!.save()
                        ibsm = IceBreakerServiceManager(connectToPeersAutomatically: true)
                        ibsm.delegate = MessagesScreen
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else
                    {
                        myUserProfile.username = newUsername
                        myUserProfile.animalIcon = animals[animalIndex]
                        myUserProfile.backgroundColor = backgrounds[backgroundIndex]
                        myUserProfile.peerID = MCPeerID(displayName: myUserProfile.username)
                        try myUserProfile.managedObjectContext!.save()
                        let avc = UIAlertController(title: "User Profile Saved", message: "Your new user profile was saved successfully!", preferredStyle: .Alert)
                        let dismiss = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        avc.addAction(dismiss)
                        self.presentViewController(avc, animated: true, completion: nil)
                    }
                    
                }
                catch let error as NSError
                {
                    print("Could not save \(error), \(error.userInfo)")
                    let avc = UIAlertController(title: "Could Not Save User Profile", message: "Your user profile could not be saved at this time. Please try again", preferredStyle: .Alert)
                    let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                    avc.addAction(dismiss)
                    self.presentViewController(avc, animated: true, completion: nil)
                }
            }
            else
            {
                let avc = UIAlertController(title: "Invalid Username", message: "Your username cannot be blank.", preferredStyle: .Alert)
                let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                avc.addAction(dismiss)
                self.presentViewController(avc, animated: true, completion: nil)
            }
        }
    }
}








