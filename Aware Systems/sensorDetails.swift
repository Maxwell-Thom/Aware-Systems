//
//  sensorDetails.swift
//  Aware Systems
//
//  Created by Maxwell on 8/5/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit
import Parse

class sensorDetails: UIViewController {
    
    //declare variables
    @IBOutlet weak var statusToggle: UISwitch!
    @IBOutlet weak var sensorName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sensorReception: UIImageView!
    @IBOutlet weak var sensorBattery: UIImageView!
    @IBOutlet weak var sensorStatus: UILabel!
    var sensorSelectionLoader = ""
    var sensorNameSet = ""
    var sensorBatteryLevel = 0
    var sensorReceptionLevel = 0
    var sensorStatusSet = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            
            dataQuery()
    }
    
    //arm/disarm toggle functionality
    
   
    @IBAction func armingSwitch(sender: AnyObject) {
        
        
        
    }
    

    //set number of rows in tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    // create cells for each row
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // create cell of homeCell type
        let cell:homeCell = self.tableView.dequeueReusableCellWithIdentifier("homeCell") as! homeCell
        // return instance of cell
        return cell
    }
    
    func dataQuery()
    {
        self.sensorSelectionLoader = SingletonB.sharedInstance.sensorSelected
        var query = PFQuery(className:"sensors")
        query.whereKey("objectId", equalTo:sensorSelectionLoader)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        // intermediate variables to change datatype to string
                        let battery = object["battery"] as! Int
                        let reception = object["reception"] as! Int
                        let status = object["arm_disarm"] as! Bool
                        let name = object["sensor_description"] as! String
                        //put variables into arrays
                        self.sensorBatteryLevel = battery
                        self.sensorReceptionLevel = reception
                        self.sensorStatusSet = status
                        self.sensorNameSet = name
                        //load view
                        self.sensorName.text = self.sensorNameSet
                        // check data recieved and initialize status text and color
                        if(self.sensorStatusSet == true)
                        {
                            //set switch
                            self.statusToggle.setOn(true, animated: false)
                            //set text
                            self.sensorStatus.text = "Armed"
                            //set color
                            self.sensorStatus.textColor = UIColor.greenColor()
                            
                        }
                            
                        else if (self.sensorStatusSet == false)
                        {
                            self.statusToggle.setOn(false, animated: false)
                            self.sensorStatus.text = "Disarmed"
                            self.sensorStatus.textColor = UIColor.redColor()
                        }
                        
                        //set battery status
                        if(self.sensorBattery == 0)
                        {
                            self.sensorBattery.image = UIImage(named: "Empty Battery-32.png")!
                        }
                            
                        else if (self.sensorBattery == 1)
                        {
                            self.sensorBattery.image = UIImage(named: "Low Battery-32-3.png")!
                        }
                            
                        else if (self.sensorBattery == 2)
                        {
                            self.sensorBattery.image = UIImage(named: "Half-Charged Battery-32.png")!
                        }
                            
                        else if (self.sensorBattery == 3)
                        {
                            self.sensorBattery.image = UIImage(named: "Charged Battery-32.png")!
                        }
                            
                        else if (self.sensorBattery == 4)
                        {
                            self.sensorBattery.image = UIImage(named: "Full Battery-32.png")!
                        }
                        
                        //set reception status
                        if(self.sensorReception == 0)
                        {
                            self.sensorReception.image = UIImage(named: "Wi-Fi-32.png")!
                        }
                            
                        else if (self.sensorReception == 1)
                        {
                            self.sensorReception.image = UIImage(named: "Wi-Fi Filled-32.png")!
                        }
                    }
                    
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
    }


}
