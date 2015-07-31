//
//  accountCreationSuccess.swift
//  Aware Systems
//
//  Created by Maxwell on 5/25/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit

class accountCreationSuccess: UIViewController
{

    @IBOutlet weak var continueSetup: UIButton!
    
    @IBAction func continueSetupButton(sender: AnyObject) {
        performSegueWithIdentifier("ContinueSetup1", sender: continueSetup)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
