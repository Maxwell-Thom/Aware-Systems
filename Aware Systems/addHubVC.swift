//
//  addHubVC.swift
//  Aware Systems
//
//  Created by Maxwell on 5/26/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit

class addHubVC: UIViewController {
    
    @IBOutlet weak var nameHub: UITextField!
    
    @IBOutlet weak var wifiOn: UISwitch!
    
    @IBOutlet weak var wifiSetup: UIButton!
    
    @IBOutlet weak var continueSetup: UIButton!
    
    var nameHubSaved: String = " "
    var wifi: Bool = false
    var nameCheck: Bool = false
    
    @IBAction func nameHubAction(sender: AnyObject) {
        
        nameHubSaved = nameHub.text
        
        if(isValidName(nameHubSaved))
        {
            nameCheck = true
            
            continueSetup.hidden = false
            
            if(wifiOn.on)
            {
                wifi = true
                
                if(nameCheck == true)
                {
                    wifiSetup.hidden = false
                    continueSetup.hidden = true
                }
            }
                
            else
            {
                wifi = false
                
                if(nameCheck == true)
                {
                    wifiSetup.hidden = true
                    continueSetup.hidden = false
                }
            }

        }
        
        else
        {
            continueSetup.hidden = true
            wifiSetup.hidden = true
        }
        
    }
    
    @IBAction func internetAccessToggle(sender: AnyObject) {
        
        
        
        if(wifiOn.on)
        {
            wifi = true
            
            if(nameCheck == true)
            {
                wifiSetup.hidden = false
                continueSetup.hidden = true
            }
        }
        
        else
        {
            wifi = false
            
            if(nameCheck == true)
            {
                wifiSetup.hidden = true
                continueSetup.hidden = false
            }
        }
        
        println(wifi)

    }

    @IBAction func wifiSetupAction(sender: AnyObject) {
        performSegueWithIdentifier("WfifSetup", sender: wifiSetup)
        writeJson(nameHubSaved)
    }
    
    @IBAction func continueSetup(sender: AnyObject) {
        writeJson(nameHubSaved)
        performSegueWithIdentifier("ContinueSetup2", sender: continueSetup)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func isValidName(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let nameRegEx = "[A-Z0-9a-z]{2,14}"
        
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluateWithObject(testStr)
    }
    
    func writeJson(name:String)
    {
        let file = "hubNameJSON.json"
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            var text = "{ \"hubName\":"+name+" }"
            
            //writing
            text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
            
            //reading
            let text2 = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
            
            println(text2)
        }
    }


}
