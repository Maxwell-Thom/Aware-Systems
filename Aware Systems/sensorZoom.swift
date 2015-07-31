//
//  sensorZoom.swift
//  Aware Systems
//
//  Created by Maxwell on 6/15/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit
import Parse

class sensorZoom: UIViewController {

    @IBOutlet weak var sensorName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //put data into a class
        /*var query = PFQuery(className:"sensors")
        query.getObjectInBackgroundWithId("1qypm3LjpF") {
            (sensor: PFObject?, error: NSError?) -> Void in
            if error == nil && sensor != nil {
                
        

            } else {
                println(error)
            }
        }*/

        self.sensorName.text = SingletonB.sharedInstance.sensorNamePayload
    }
    
    var cheeseArr: [String] = ["the Battery is under 50%","Sensor is armed", "Sensor is moving!"]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cheeseArr.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell:homeCell = self.tableView.dequeueReusableCellWithIdentifier("homeCell") as! homeCell
        
        //cell.logMessage!.text = cheeseArr[indexPath.row]
        
        return cell
    }
        
    @IBAction func silenceAlert(sender: AnyObject) {

        
        var statusUpdate = PFObject(className: "sensors")
        statusUpdate.objectId = SingletonB.sharedInstance.sensorIdPayload
        statusUpdate["movement_flag"] = false;
        
        
        statusUpdate.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("homeHub") as! homeHub
                
                self.presentViewController(destinationViewController, animated: true, completion:nil)
                // The object has been saved.
                println("saved!")
            } else {
                // There was a problem, check error.description
            }
        }
        

    }




    
}
