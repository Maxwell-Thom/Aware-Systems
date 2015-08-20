//
//  ViewController.swift
//  Aware Systems
//
//  Created by Maxwell on 5/21/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!

    //ADD SETTINGS TO THIS LIST TO CREATE MORE SETTINGS
    var settingsArr: [String] = ["Create Account","Add Hubs","Add Sensors","Alert Escalation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return settingsArr.count;
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
    let cell:settingsCell = self.tableView.dequeueReusableCellWithIdentifier("settingsCell") as! settingsCell
    
    cell.settingName!.text = settingsArr[indexPath.row]
    
    return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier(settingsArr[indexPath.row], sender: settingsCell.self)
        
    }
    

}

