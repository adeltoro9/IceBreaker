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
    
    @IBOutlet weak var imgvwBackground: UIImageView!
    @IBOutlet weak var imgvwAnimalIcon: UIImageView!
    @IBOutlet weak var txfldUserInput: UITextField!
    
    override func viewWillAppear(animated: Bool)
    {
        txfldUserInput.text = myUserInfo.username
        animalIndex = animals.indexOf(myUserInfo.animalIcon)!
        imgvwAnimalIcon.image = UIImage(named: self.animals[self.animalIndex])
        backgroundIndex = backgrounds.indexOf(myUserInfo.backgroundColor)!
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
    
    
    // TODO ADD AVC FOR EACH CASE
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
                    myUserInfo.username = newUsername
                    myUserInfo.animalIcon = animals[animalIndex]
                    myUserInfo.backgroundColor = backgrounds[backgroundIndex]
                    myUserInfo.peerID = MCPeerID(displayName: myUserInfo.username)
                    try myUserInfo.managedObjectContext!.save()
                    let avc = UIAlertController(title: "User Profile Saved", message: "Your new user profile was saved successfully!", preferredStyle: .Alert)
                    let dismiss = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    avc.addAction(dismiss)
                    self.presentViewController(avc, animated: true, completion: nil)
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








