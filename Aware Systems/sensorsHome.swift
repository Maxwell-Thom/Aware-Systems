//
//  sensorsHome.swift
//  Aware Systems
//
//  Created by Maxwell on 6/1/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit
import Parse

class sensorsHome: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var rows: Int = 0
    var sensorId: String = ""
    var sensorDescription:[String] = []
    var relatedSensors:[String] = []
    var hubSelectionLoader: String = ""
    var sensorStatus: [Bool] = []
    var selectedSensorId: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataQuery()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backbutton(sender: AnyObject) {
        
        self.rows = 0
        self.sensorId = ""
        self.sensorDescription.removeAll(keepCapacity: false)
        self.relatedSensors.removeAll(keepCapacity: false)
        self.hubSelectionLoader = ""
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.rows
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell:homeCell = self.tableView.dequeueReusableCellWithIdentifier("homeCell") as! homeCell
        
        cell.hubName!.text = sensorDescription[indexPath.row]
        
        if(self.sensorStatus[indexPath.row] == true)
        {
            cell.hubStatus.text = "Armed"
            cell.hubStatus.textColor = UIColor.greenColor()

        }
        
        else if (self.sensorStatus[indexPath.row] == false)
        {
            cell.hubStatus.text = "Disarmed"
            cell.hubStatus.textColor = UIColor.redColor()
        }
        
        return cell
    }
    
    //expiremental
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) ->[AnyObject]? {
    var shareAction = UITableViewRowAction(style: .Normal, title: "Inspect") { (action, indexPath) -> Void in
    tableView.editing = false
    let cell:homeCell = self.tableView.dequeueReusableCellWithIdentifier("homeCell") as! homeCell
    println("shareAction")
    }
    shareAction.backgroundColor = UIColor.grayColor()
    
    var armAction = UITableViewRowAction(style: .Default, title: "Arm") { (action, indexPath) -> Void in
        tableView.editing = true
        var statusUpdate = PFObject(className: "sensors")
        statusUpdate.objectId = self.selectedSensorId[indexPath.row]
        statusUpdate["arm_disarm"] = true;

        statusUpdate.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("saved!")
                
            } else {
                // There was a problem, check error.description
            }
                    self.tableView.reloadData()
        }
        self.sensorStatus[indexPath.row] = true
        self.tableView.reloadData()
    }
        
    armAction.backgroundColor = UIColor.greenColor()
    
    var disarmAction = UITableViewRowAction(style: .Default, title: "Disarm") { (action, indexPath) -> Void in
        tableView.editing = true
        var statusUpdate = PFObject(className: "sensors")
        statusUpdate.objectId = self.selectedSensorId[indexPath.row]
        statusUpdate["arm_disarm"] = false;
        
        
        statusUpdate.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("saved!")
            } else {
                // There was a problem, check error.description
            }
        }
        self.sensorStatus[indexPath.row] = false
        self.tableView.reloadData()
    }
    return [disarmAction, armAction/*, shareAction*/]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }

    
    
    
    
    
    func dataQuery()
    {
        self.hubSelectionLoader = SingletonB.sharedInstance.hubSelected
        var counter: Int = 0
        // Do any additional setup after loading the view, typically from a nib.
        
        //specify class
        var testQuery = PFQuery(className: "hubs")
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
                        var queryArr = object["Sensors"] as! NSArray
                        //count the array for loop and table size
                        var loopCount = queryArr.count
                        self.rows = loopCount
                        //loop through queryArr
                        while(counter < loopCount){
                            //set variables to be extracted from dictionary
                            let description = queryArr[counter].valueForKey("sensor_description") as! String
                            let status = queryArr[counter].valueForKey("arm_disarm") as! Bool
                            let sensorId = queryArr[counter].valueForKey("objectId") as! String
                            //put variables into external variables for later use
                            self.sensorDescription.append(description)
                            self.sensorStatus.append(status)
                            self.selectedSensorId.append(sensorId)
                            //increment counter
                            counter = counter+1
                            
                        }
                        
                    }
                    //reload table with new data
                    println(self.sensorStatus)
                    self.tableView.reloadData()
                }
            }
                
            else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
}
