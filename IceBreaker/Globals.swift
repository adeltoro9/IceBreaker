//
//  Globals.swift
//  BasicMessenger
//
//  Created by Anthony Del Toro on 4/18/16.
//  Copyright © 2016 AnthonyDDelToro. All rights reserved.
//

import MultipeerConnectivity
import UIKit

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