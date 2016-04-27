//
//  Globals.swift
//  BasicMessenger
//
//  Created by Anthony Del Toro on 4/18/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import MultipeerConnectivity
import UIKit

// Service type must be a unique string, at most 15 characters long
// and can contain only ASCII lowercase letters, numbers and hyphens.
let IceBreakerServiceType = "icebreaker-chat"

var ibsm: IceBreakerServiceManager!

let DEFAULT_LIFETIME = 10

var myPeerID: MCPeerID
{
    get
    {
        return _peerID
    }
    
    set
    {
        _peerID = newValue
    }
}

private var _peerID = MCPeerID(displayName: UIDevice.currentDevice().name)

var _messagesScreen: IceBreakerServiceManagerDelegate! = nil

var MessagesScreen: IceBreakerServiceManagerDelegate?
{
    get
    {
        if let nvc = ((UIApplication.sharedApplication().windows[0].rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController)
        {
            for vc in nvc.viewControllers
            {
                if let ibsmd = ((vc as? MessagesViewController) as? IceBreakerServiceManagerDelegate)
                {
                    return ibsmd
                }
            }
        }
        
        return nil
    }

    /*
    set
    {
        _messagesScreen = newValue
    }
    */
}

var bIsSimulator: Bool =
{
   return (TARGET_OS_SIMULATOR == 1)
}()

extension UIApplication
{
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController?
    {
        
        if let nvc = base as? UINavigationController
        {
            return topViewController(nvc.visibleViewController)
        }
        
        if let tbc = base as? UITabBarController
        {
            let moreNavigationController = tbc.moreNavigationController
            
            if let top = moreNavigationController.topViewController where top.view.window != nil
            {
                return topViewController(top)
            }
            else if let selected = tbc.selectedViewController
            {
                return topViewController(selected)
            }
        }
        
        if let pvc = base?.presentedViewController
        {
            return topViewController(pvc)
        }
        
        return base
    }
}