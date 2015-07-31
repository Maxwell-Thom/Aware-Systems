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
  
    @IBOutlet weak var tableView: UITableView!
    
    var rows: Int = 0
    var hubSelection: String = ""
    var hubDescription:[String] = []
    var selectedHubId: [String] = []
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
        

        
        var counter: Int = 0
        
        var query = PFQuery(className:"hubs")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                self.rows = objects!.count
                self.tableView.reloadData()
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        let description = object["hub_description"] as! String
                        let hubId = object.objectId
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
        
        tableView.reloadData()
    }
    
     override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

    return self.rows
    }
    
     func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
    
    let cell:homeCell = self.tableView.dequeueReusableCellWithIdentifier("homeCell") as! homeCell
        
    cell.hubName!.text = hubDescription[indexPath.row]
    
    return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        SingletonB.sharedInstance.hubSelected = selectedHubId[indexPath.row]
        

        }
    
    }
