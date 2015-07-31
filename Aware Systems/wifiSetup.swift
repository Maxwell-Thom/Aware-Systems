//
//  wifiSetup.swift
//  Aware Systems
//
//  Created by Maxwell on 5/26/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit

class wifiSetup: UIViewController {
    
    @IBOutlet weak var wifiNameLabel: UILabel!
    
    @IBOutlet weak var submitPass: UIButton!
    
    @IBOutlet weak var connectSuccess: UILabel!
    
    @IBOutlet weak var testingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var continueSetup: UIButton!
    
    @IBAction func wifiPasswordAction(sender: AnyObject) {
    }
    
    
    @IBAction func submitAction(sender: AnyObject) {
    }
    
    @IBAction func continueSetupAction(sender: AnyObject) {
        
        performSegueWithIdentifier("ContinueSetup3", sender: continueSetup)
    }
    
    func isValidWifiPass(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let wifiPassRegEx = "[A-Z0-9a-z]{1,25}"
        
        let wifiPassTest = NSPredicate(format:"SELF MATCHES %@", wifiPassRegEx)
        return wifiPassTest.evaluateWithObject(testStr)
    }

}
