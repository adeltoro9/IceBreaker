//
//  SettingsViewController.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 5/2/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

//import Cocoa
import UIKit

class SettingsViewController: UIViewController
{
    let animals: [String] = ["Alligator", "Bat", "Bear", "Beaver", "Bee", "Bull", "Caterpillar", "Crab", "Dragon", "Goat", "Leopard", "Ox", "Pelican", "Pig", "Rat", "Tiger"]
    let backgrounds: [String] = ["red", "orange", "yellow", "green", "blue",  "purple", "pink"]
    
    var animalIndex: Int = 0
    var backgroundIndex: Int = 0
    
    @IBOutlet weak var imgvwBackground: UIImageView!
    @IBOutlet weak var imgvwAnimalIcon: UIImageView!
    @IBOutlet weak var txfldUserInput: UITextField!
    
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
    
    }
}
