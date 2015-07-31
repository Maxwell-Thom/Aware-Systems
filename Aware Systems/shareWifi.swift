//
//  shareWifi.swift
//  Aware Systems
//
//  Created by Maxwell on 5/27/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit

class shareWifi: UIViewController {
    
    @IBOutlet weak var contWifiSetup: UIButton!
    
    @IBOutlet weak var wifiName: UITextField!
    
    var wifiNameSaved: String = " "
    
    @IBAction func wifiNameAction(sender: AnyObject) {
        
        wifiNameSaved = wifiName.text
        
        if(isValidName(wifiNameSaved))
        {
            contWifiSetup.hidden = false
            
        }
            
        else
        {
            contWifiSetup.hidden = true
        }
    }


    @IBAction func contWifiSetupAction(sender: AnyObject) {
        
        performSegueWithIdentifier("WfifSetup2", sender: contWifiSetup)
    }
    
    func isValidName(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let nameRegEx = "[A-Z0-9a-z]{1,25}"
        
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluateWithObject(testStr)
    }
}
