//
//  AppDelegate.swift
//  QuotieAaron2
//
//  Created by Aaron Lopez on 7/13/17.
//  Copyright © 2017 Aaron Lopez. All rights reserved.
//

import UIKit
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let branch: Branch = Branch.getInstance()
        branch.setDebug()
        
        
        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
            if error == nil {
                // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
                // params will be empty if no data found
                // ... insert custom logic here ...
                print("INIT SESSION: params: %@", params as? [String: AnyObject] ?? {})
            }
        })
        //branch.setDebug()
        return true
    }
    
    // Respond to URI scheme links
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // pass the url to the handle deep link call
        
        Branch.getInstance().application(app, open: url, options: options)
        
        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
        return true
    }
    
    // Respond to Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        
        Branch.getInstance().continue(userActivity)

        return false
    }

}

