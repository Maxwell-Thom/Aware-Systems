//
//  homeCell.swift
//  Aware Systems
//
//  Created by Maxwell on 6/9/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit
import Parse

class homeCell: UITableViewCell {
    //declare variables (give these variables better names! they are used in both sensors and hubs)
    var index = 0
    
    var objectId = ""
    
    @IBOutlet weak var hubName: UILabel!
    
    @IBOutlet weak var hubStatus: UILabel!

    @IBOutlet weak var sensorReception: UIImageView!
    
    @IBOutlet weak var sensorImage: UIImageView!
    
    @IBOutlet weak var sensorBattery: UIImageView!
    
    @IBOutlet weak var armingSwitch: UISwitch!
    
    @IBAction func armingSwitchAction(sender: AnyObject) {
        
        let statusUpdate = PFObject(className: "sensors")
        
        // set the object id of the PFobject to the object id of the selected cell
        statusUpdate.objectId = objectId
        
        if(armingSwitch.on){
            // set arm_disarm to true
            statusUpdate["arm_disarm"] = true;
            self.hubStatus.text = "Armed"
            //set color
            self.hubStatus.textColor = UIColor( red: 0/255, green: 142/255, blue:65/255, alpha: 1.0  )
            
        }
            
        else{
            statusUpdate["arm_disarm"] = false;
            self.hubStatus.text = "Disarmed"
            self.hubStatus.textColor = UIColor.redColor()
        }
        
        // update object of specified id
        statusUpdate.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                
                // There was a problem, check error.description
            }
        }
    }
}
