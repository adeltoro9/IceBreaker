//
//  MessagesViewController.swift
//  IceBreaker
//
//  Created by Anthony Del Toro on 4/18/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MessagesViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var txvwMessages: UITextView!
    
    @IBOutlet weak var txfldMessageInput: UITextField!
    
    var ibsm: IceBreakerServiceManager!
    
    //var frameView: UIView!
    
    var originalTextViewFrame: CGRect!
    
    //var originalContentSize: CGSize!
    
    var keyboardHeight: CGFloat!
    
    var bKeyboardIsVisible: Bool!
    
    var originalYCoordinate: CGFloat!
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        originalTextViewFrame = txvwMessages.frame
        
        print("X: \(self.txvwMessages.frame.origin.x)\nY: \(self.txvwMessages.frame.origin.y)\nWidth :\(self.txvwMessages.frame.size.width)\nHeight :\(self.txvwMessages.frame.size.height)")
        
        //originalContentSize = txvwMessages.contentSize
        
        // Keyboard stuff.
        if (!bIsSimulator)
        {
            let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
            center.addObserver(self, selector: #selector(MessagesViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
            center.addObserver(self, selector: #selector(MessagesViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        }
        else
        {
            print("Simulator detected.")
        }
        
        bKeyboardIsVisible = false
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        
        ibsm = IceBreakerServiceManager(connectToPeersAutomatically: true)
        ibsm.delegate = self
        
        // Keyboard stuff.
        if (!bIsSimulator)
        {
            let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
            center.addObserver(self, selector: #selector(MessagesViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
            center.addObserver(self, selector: #selector(MessagesViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        }
        else
        {
            print("Simulator detected.")
        }
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        ibsm.delegate = nil
        ibsm = nil
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        super.viewDidDisappear(true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        txfldMessageInput.resignFirstResponder()
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
        if textField == txfldMessageInput
        {
            // FIXME remove once textview's size adjusts automatically
            
            textField.resignFirstResponder()
            self.view.endEditing(true)
            btnSendMessage_TouchUpInside(self)
            return false
        }
        return true
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if (bKeyboardIsVisible != nil) && (bKeyboardIsVisible == true)
        {
            // do not want to move stuff around once the keyboard is already displayed
            return
        }
        
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        keyboardHeight = keyboardSize.height
        
        let myScreenRect: CGRect = UIScreen.mainScreen().bounds

        var needToMove: CGFloat = 0
        
        if let nvc = self.navigationController
        {
            if (txvwMessages.frame.origin.y + txvwMessages.frame.size.height + nvc.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height > (myScreenRect.size.height - (keyboardHeight + 15)))
            {
                needToMove = (txvwMessages.frame.origin.y + txvwMessages.frame.size.height + nvc.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height) - (myScreenRect.size.height - (keyboardHeight + 15));
            }
        }
        else
        {
            if (txvwMessages.frame.origin.y + txvwMessages.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height > (myScreenRect.size.height - (keyboardHeight + 35)))
            {
                needToMove = (txvwMessages.frame.origin.y + txvwMessages.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height) - (myScreenRect.size.height - (keyboardHeight + 35))
            }
        }
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
        {
            let frameMainView : CGRect = CGRectMake(0, -needToMove, self.view.bounds.width, (self.view.bounds.height + 10))
            self.view.frame = frameMainView
            
            // FIXME: GET TEXTVIEW TO ADJUST SIZE WHEN KEYBOARD APPEARS
            
            //let frameTextView : CGRect = CGRectMake(self.txvwMessages.frame.origin.x, (self.txvwMessages.frame.origin.y + needToMove), self.txvwMessages.frame.size.width, (self.txvwMessages.frame.size.height - needToMove))
            //self.txvwMessages.frame = frameTextView
            
            //let newContentSize: CGSize = CGSize(width: self.txvwMessages.contentSize.width, height: (self.txvwMessages.contentSize.height - needToMove))
            //self.txvwMessages.contentSize = newContentSize
            
            //var sizeThatFitsContent: CGSize = self.txvwMessages.sizeThatFits(self.txvwMessages.frame.size)
            //sizeThatFitsContent.height = sizeThatFitsContent.height //- needToMove
        }, completion:
        { (finished) in
                if (finished)
                {
                    print("X: \(self.txvwMessages.frame.origin.x)\nY: \(self.txvwMessages.frame.origin.y)\nWidth :\(self.txvwMessages.frame.size.width)\nHeight :\(self.txvwMessages.frame.size.height)")
                }
        })
        
        bKeyboardIsVisible = true
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        keyboardHeight = keyboardSize.height
        
        let _: CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber as CGFloat
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
        {
            let frame : CGRect = CGRectMake(0, 0, self.view.bounds.width, (self.view.bounds.height - 10))
            self.view.frame = frame
            
            //self.txvwMessages.frame = self.textViewFrame
        }, completion:
        { (finished) in
                if (finished)
                {
                    //print("X: \(self.txvwMessages.frame.origin.x)\nY: \(self.txvwMessages.frame.origin.y)\nWidth :\(self.txvwMessages.frame.size.width)\nHeight :\(self.txvwMessages.frame.size.height)")
                }
        })
        
        bKeyboardIsVisible = false
    }
    
    @IBAction func btnSendMessage_TouchUpInside(sender: AnyObject)
    {
        if let message = txfldMessageInput.text
        {
            if !ibsm.sendPacket(IBPacket(sender: myPeerID, recipient: nil, type: IBPacketType.Sports, message: message, timeStamp: NSDate(), lifeTime: DEFAULT_LIFETIME), bPrintMessageToScreen: true)
            {
                printMessageToScreen(ibsm, strMessage: "Error could not send message")
            }
            else
            {
                txfldMessageInput.text = ""
            }
        }
    }
    
    @IBAction func btnConnectPeers_TouchUpInside(sender: AnyObject)
    {
        let mcb = MCBrowserViewController(serviceType: IceBreakerServiceType, session: ibsm.session)
        mcb.delegate = self
        presentViewController(mcb, animated: true, completion: nil)
    }
    
}

//# MARK: - IceBreakerServiceManagerDelegate Protocol
extension MessagesViewController: IceBreakerServiceManagerDelegate
{
    func connectedDevicesChanged(manager : IceBreakerServiceManager, connectedDevices: [String])
    {
        printMessageToScreen(ibsm, strMessage: "Connected devices: \(connectedDevices)")
    }
    
    func printMessageToScreen(manager: IceBreakerServiceManager, strMessage: String)
    {
        if self == UIApplication.topViewController()
        {
            // Adding text to the textview must be done on the MAIN thread
            if NSThread.isMainThread()
            {
                self.txvwMessages.text = self.txvwMessages.text + strMessage + "\n"
                
                // Scrolls textview to bottom after each new message is printed
                let caretRect: CGRect = self.txvwMessages.caretRectForPosition(self.txvwMessages.endOfDocument)
                self.txvwMessages.scrollRectToVisible(caretRect, animated: false)
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),
                {
                    self.txvwMessages.text = self.txvwMessages.text + strMessage + "\n"
                    
                    // Scrolls textview to bottom after each new message is printed
                    let caretRect: CGRect = self.txvwMessages.caretRectForPosition(self.txvwMessages.endOfDocument)
                    self.txvwMessages.scrollRectToVisible(caretRect, animated: false)
                })
            }
        }
        else
        {
            print(strMessage)
        }
    }
}

//# MARK: - MCBrowserViewControllerDelegate Protocol
extension MessagesViewController: MCBrowserViewControllerDelegate
{
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController)
    {
        /*
         Parameters
         browserViewController
         The view controller that was dismissed.
         Discussion
         This call is intended to inform your app that the user has connected with nearby peers in a session and that the browser view controller has been dismissed. Upon receiving this delegate method call, your app must call dismissViewControllerAnimated:completion: to dismiss the view controller. Your app can also begin sending data to any connected peers, and should resume any UI updates that it may have temporarily suspended while the view controller was onscreen.
         */
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController)
    {
        /*
         Parameters
         browserViewController
         The browser view controller that was canceled.
         Discussion
         This call is intended to inform your app that the view controller has been dismissed because the user canceled the discovery process and is no longer interested in creating a communication session.
         
         When your app receives this delegate method call, your app must call dismissViewControllerAnimated:completion: to dismiss the view controller. Then, your app should handle the cancelation in whatever way is appropriate for your app, and then resume any UI updates that it may have temporarily suspended while the view controller was onscreen.
        */
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewController(browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool
    {
        /*
         Parameters
         browserViewController
         The browser view controller object that discovered the new peer.
         peerID
         The unique ID of the nearby peer.
         info
         The info dictionary advertised by the discovered peer. For more information on the contents of this dictionary, see the documentation for initWithPeer:discoveryInfo:serviceType: in MCNearbyServiceAdvertiser Class Reference.
         Return Value
         This delegate method should return true if the newly discovered peer should be shown in the user interface, or false otherwise.
         
         Discussion
         If this method is not provided, all peers are shown.
         */
        return true
    }
}