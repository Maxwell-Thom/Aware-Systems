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
        // assign name from singleton (the names is sent in the notification payload and the notification is sent from the payload)
        self.sensorName.text = SingletonB.sharedInstance.sensorNamePayload
    }
    
    // set number of rows in tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    //create cells for rows
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //create cell of homeCell type
        let cell:homeCell = self.tableView.dequeueReusableCellWithIdentifier("homeCell") as! homeCell
        //return instance of cell
        return cell
    }
    
    // action for silence alert button
    @IBAction func silenceAlert(sender: AnyObject) {
        // create pfobject
        var statusUpdate = PFObject(className: "sensors")
        // get id from notification payload through singleton method, put into pfobject
        statusUpdate.objectId = SingletonB.sharedInstance.sensorIdPayload
        // set movement_flag to false inside of pfobject
        statusUpdate["movement_flag"] = false;
        // save object to DB
        statusUpdate.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // exit back to hub page but reintialize the navigation controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                // set view to homehub
                let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("homeHub") as! homeHub
                //segue
                self.presentViewController(destinationViewController, animated: true, completion:nil)
                // The object has been saved.
                println("saved!")
            } else {
                // There was a problem, check error.description
            }
        }
    }




    
}
