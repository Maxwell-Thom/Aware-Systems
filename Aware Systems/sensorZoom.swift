//
//  sensorZoom.swift
//  Aware Systems
//
//  Created by Maxwell on 6/15/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit
import Parse
//import Charts

class sensorZoom: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var sensorName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var atLocation: UILabel!
    @IBOutlet weak var sendText: UIButton!
    @IBOutlet weak var makeCall: UIButton!
    @IBOutlet weak var Escalate: UIButton!
    @IBOutlet weak var silenceAlert: UIButton!
   // @IBOutlet weak var lineChartView: LineChartView!
    
    var hubDescription : [String] = []
    var hubRelations : [NSArray] = []
    var months: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assign name from singleton (the names is sent in the notification payload and the notification is sent from the payload)
        self.sensorName.text = SingletonB.sharedInstance.sensorNamePayload
        self.dataQueryInhubs()
        
        //chart stuff
        
        makeCall.layer.cornerRadius = 15
        sendText.layer.cornerRadius = 15
        Escalate.layer.cornerRadius = 15
        silenceAlert.layer.cornerRadius = 15
        self.tableView.separatorColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 )

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let popupView = segue.destinationViewController as? UIViewController
        {
            if let popup = popupView.popoverPresentationController
            {
                popup.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
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
        let statusUpdate = PFObject(className: "sensors")
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
                let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("sensorsHome") as! sensorsHome
                
                let window = UIApplication.sharedApplication().windows[0] as UIWindow;
                window.rootViewController = destinationViewController;
                
                
                
                //performSegueWithIdentifier("goHome", sender:self.silenceAlert)
                // The object has been saved.
                print("saved!", terminator: "")
            } else {
                // There was a problem, check error.description
            }
        }
        
        // create query
        let deleteNews = PFQuery(className: "news")
        deleteNews.whereKey("sensorId", equalTo: SingletonB.sharedInstance.sensorIdPayload)
        deleteNews.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        object.deleteInBackground()
                            
                        }
                        
                    }
                }
        }
    }
    
    func setHubName(){
        
        var counter = 0
        
        while(counter < hubDescription.count){
            
            if(self.hubRelations[counter].containsObject(SingletonB.sharedInstance.sensorIdPayload)){
                atLocation.text = "@ " + hubDescription[counter]
                counter = hubDescription.count
            }
                
            else{
                counter++
            }
        }
    
    }
    
    
    func dataQueryInhubs(){
        let queryNews = PFQuery(className: "hubs")
        
        queryNews.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        let relations = object["Sensors"] as! NSArray
                        let description = object["hub_description"] as! String
                        self.hubRelations.append(relations.valueForKey("objectId") as! NSArray)
                        self.hubDescription.append(description)
                    }
                    
                }
                
                self.setHubName()
            }
        }
    }
    
    //Chart Stuff
    
    /*func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartData.setValueTextColor(UIColor.whiteColor())
        lineChartView.data = lineChartData
        lineChartView.descriptionText = ""
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        
    }*/

}
