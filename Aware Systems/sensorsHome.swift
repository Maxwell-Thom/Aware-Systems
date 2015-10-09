//
//  sensorsHome.swift
//  Aware Systems
//
//  Created by Maxwell on 6/1/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit
import Parse
import QuartzCore

class sensorsHome: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //declare variables
    @IBOutlet var tableView: UITableView!
    

    
    var rows: Int = 0
    var sensorId: String = ""
    var sensorDescription:[String] = []
    var relatedSensors:[String] = []
    var hubSelectionLoader: String = ""
    var sensorStatus: [Bool] = []
    var selectedSensorId: [String] = []
    var sensorReception: [Int] = []
    var sensorBattery: [Int] = []
    var sensorMovement: [Bool] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        //call dataquery and populate view upon loading
        self.rows = 0
        self.sensorId = ""
        self.sensorDescription.removeAll(keepCapacity: false)
        self.relatedSensors.removeAll(keepCapacity: false)
        self.hubSelectionLoader = ""
        self.sensorStatus.removeAll(keepCapacity: false)
        self.selectedSensorId.removeAll(keepCapacity: false)
        self.sensorReception.removeAll(keepCapacity: false)
        self.sensorBattery.removeAll(keepCapacity: false)
        self.sensorMovement.removeAll(keepCapacity: false)
        
        self.dataQuery()

    }
    
    func refresh(refreshControl: UIRefreshControl) {
        viewDidLoad()
        refreshControl.endRefreshing()
    }
    
    //specify number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //rows is generated from the amount of items that the server sends
        return self.rows
    }
    
    //generates cells for table view and initializes the view
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // create cell of homeCell type
        let cell:homeCell = self.tableView.dequeueReusableCellWithIdentifier("homeCell") as! homeCell
        //set index in cell
        cell.index = indexPath.row
        //set objectId
        cell.objectId = selectedSensorId[indexPath.row]
        // set cell title (the name of the hub)
        cell.hubName!.text = sensorDescription[indexPath.row]
        
        // check data recieved and initialize status text and color
        if(self.sensorStatus[indexPath.row] == true)
        {
            cell.armingSwitch.on = true
            //set text
            cell.hubStatus.text = "Armed"
            //set color
            cell.hubStatus.textColor = UIColor( red: 0/255, green: 142/255, blue:65/255, alpha: 1.0  )
        }
        
        else if (self.sensorStatus[indexPath.row] == false)
        {
            cell.armingSwitch.on = false
            cell.hubStatus.text = "Disarmed"
            cell.hubStatus.textColor = UIColor.redColor()
        }
       
        
        //set battery status
        if(self.sensorBattery[indexPath.row] == 0)
        {
            cell.sensorBattery.image = UIImage(named: "Empty Battery-32.png")!
        }
            
        else if (self.sensorBattery[indexPath.row] == 1)
        {
            cell.sensorBattery.image = UIImage(named: "Low Battery-32-3.png")!
        }
            
        else if (self.sensorBattery[indexPath.row] == 2)
        {
            cell.sensorBattery.image = UIImage(named: "Half-Charged Battery-32.png")!
        }
            
        else if (self.sensorBattery[indexPath.row] == 3)
        {
            cell.sensorBattery.image = UIImage(named: "Charged Battery-32.png")!
        }
            
        else if (self.sensorBattery[indexPath.row] == 4)
        {
            cell.sensorBattery.image = UIImage(named: "Full Battery-32.png")!
        }
        
        //set reception status
        if(self.sensorReception[indexPath.row] == 0)
        {
            cell.sensorReception.image = UIImage(named: "Wi-Fi-32.png")!
        }
            
        else if (self.sensorReception[indexPath.row] == 1)
        {
            cell.sensorReception.image = UIImage(named: "Wi-Fi Filled-32.png")!
        }
        
        
        cell.sensorImage.layer.cornerRadius = 10
        
        
        return cell
    }
    
    // specifiy actions for if a cell is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //use singleton variable to record which cell was selected, i use this in sensor details to set title.
        SingletonB.sharedInstance.sensorSelected = selectedSensorId[indexPath.row]
        
        selectedSensorId.removeAll(keepCapacity: false)
        sensorDescription.removeAll(keepCapacity: false)
        
        // perform segue after setting sensorSelected
        performSegueWithIdentifier("sensorDetails", sender: homeCell.self)
    }
    
   //controls and adds actions to cell
   func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) ->[UITableViewRowAction]?{
        // create two seperate actions, arm and disarm
        // declare action and specify title and type
        let armAction = UITableViewRowAction(style: .Default, title: "Arm") { (action, indexPath) -> Void in
            
            // enable editing on tableview
            tableView.editing = true
            // query database to update values
            // create PFobject for sensors table query
            let statusUpdate = PFObject(className: "sensors")
            
            // set the object id of the PFobject to the object id of the selected cell
            statusUpdate.objectId = self.selectedSensorId[indexPath.row]
            
            // set arm_disarm to true
            statusUpdate["arm_disarm"] = true;
            
            // update object of specified id
            statusUpdate.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                // The object has been saved.
                } else {
                    
                // There was a problem, check error.description
                }
            }
            
            //reload table view to reflect changes
            self.sensorStatus[indexPath.row] = true
            self.tableView.reloadData()
        }
    //set action buttons color
    armAction.backgroundColor = UIColor.greenColor()
    
    // see comments for armAction. the functionality is identical
        let disarmAction = UITableViewRowAction(style: .Default, title: "Disarm") { (action, indexPath) -> Void in
        
            tableView.editing = true
            let statusUpdate = PFObject(className: "sensors")
            statusUpdate.objectId = self.selectedSensorId[indexPath.row]
            statusUpdate["arm_disarm"] = false;
        
        
                statusUpdate.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.

                    } else {
                        // There was a problem, check error.description
                    }
                }
        
            self.sensorStatus[indexPath.row] = false
            self.tableView.reloadData()
            }
    
        // only show actions that are releveant to user
        if(sensorStatus[indexPath.row] == true){
            // show disarm if sensor is currently armed
            return [disarmAction]
        }
    
        else {
            // show arm if sensor is currently disarmed
            return [armAction]
        }
    }
    
    // set the changes to the tableview
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    //
    func dataQuery()
    {
        self.hubSelectionLoader = SingletonB.sharedInstance.hubSelected
        var counter: Int = 0
        // Do any additional setup after loading the view, typically from a nib.
        
        //specify class
        let testQuery = PFQuery(className: "hubs")
        //specify which hub
        testQuery.whereKey("objectId", equalTo: self.hubSelectionLoader)
        // include relational array
        testQuery.includeKey("Sensors")
        // get query
        testQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    
                    for object in objects {
                        //load array from query as nsarray
                        let queryArr = object["Sensors"] as! NSArray
                        //count the array for loop and table size
                        let loopCount = queryArr.count
                        self.rows = loopCount
                        //loop through queryArr
                        while(counter < loopCount){
                            //set variables to be extracted from dictionary
                            let description = queryArr[counter].valueForKey("sensor_description") as! String
                            let status = queryArr[counter].valueForKey("arm_disarm") as! Bool
                            let movement = queryArr[counter].valueForKey("movement_flag") as! Bool
                            let sensorId = queryArr[counter].valueForKey("objectId") as! String
                            let reception = queryArr[counter].valueForKey("reception") as! Int
                            let battery = queryArr[counter].valueForKey("battery") as! Int
                            //put variables into external variables for later use
                            self.sensorDescription.append(description)
                            self.sensorStatus.append(status)
                            self.selectedSensorId.append(sensorId)
                            self.sensorReception.append(reception)
                            self.sensorBattery.append(battery)
                            self.sensorMovement.append(movement)
                            //increment counter
                            counter = counter+1
                            
                        }
                        
                    }
                    
                    //reload table with new data
                    self.tableView.reloadData()
                }
            }
                
            else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)", terminator: "")
            }
        }
    }
}
