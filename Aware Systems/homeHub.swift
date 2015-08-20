//
//  homeHub.swift
//  Aware Systems
//
//  Created by Maxwell on 6/9/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit
import Parse

class homeHub: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    //declare variables
    @IBOutlet weak var tableView: UITableView!
    var rows: Int = 0
    var hubSelection: String = ""
    var hubDescription:[String] = []
    var hubStatus: [Bool] = []
    var selectedHubId: [String] = []
    
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
        //declare variables
        var counter: Int = 0
        //create PFQuery object
        var query = PFQuery(className:"hubs")
        //search query for all objects in hubs table
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                //set rows equal to the number of objects found
                self.rows = objects!.count
                //reload the table
                self.tableView.reloadData()
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    // do something to each object in objects
                    for object in objects {
                        // intermediate variables to change datatype to string
                        let description = object["hub_description"] as! String
                        let status = object["hub_status"] as! Bool
                        let hubId = object.objectId
                        //put variables into arrays
                        self.hubStatus.append(status)
                        self.hubDescription.append(description)
                        self.selectedHubId.append(hubId!)
                    }
                }
            }
            
            else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
        //reload view
        tableView.reloadData()
    }
    
     override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    // set table view rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // set rows to the number of elements the DB provided
        return self.rows
    }
    
    // create cells in table view
    func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
    // create cell of homeCell
    let cell:homeCell = self.tableView.dequeueReusableCellWithIdentifier("homeCell") as! homeCell
        
    // set title of cell
    cell.hubName!.text = hubDescription[indexPath.row]
        
    //set status of hub (activated/deactivated)
        if(self.hubStatus[indexPath.row] == true)
        {
            //set text
            cell.hubStatus.text = "Activated"
            //set color
            cell.hubStatus.textColor = UIColor.greenColor()
            
        }
            
        else if (self.hubStatus[indexPath.row] == false)
        {
            cell.hubStatus.text = "Deactivated"
            cell.hubStatus.textColor = UIColor.redColor()
        }
    // return instance of cell
    return cell
    }
    
    //specify action for selecting tableview cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //set hub selection
        SingletonB.sharedInstance.hubSelected = selectedHubId[indexPath.row]
    }
    
}
