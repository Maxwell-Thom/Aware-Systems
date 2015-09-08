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
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!

    
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var sensorSelectionLoader = ""
    var sensorNameSet = ""
    var loggingCodes:[Int] = []
    var loggingDates:[String] = []
    var loggingTimes: [String] = []
    var sensorBatteryLevel = 0
    var sensorReceptionLevel = 0
    var sensorStatusSet = true
    var tableViewSize = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            
            dataQuery()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadFunction:", name:"reloadTableView", object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
        self.calendarView.commitCalendarViewUpdate()
        self.menuView.commitMenuViewUpdate()
        

    }

    //arm/disarm toggle functionality
    @IBAction func armingSwitch(sender: AnyObject) {
        
        var statusUpdate = PFObject(className: "sensors")
        
        // set the object id of the PFobject to the object id of the selected cell
        statusUpdate.objectId = SingletonB.sharedInstance.sensorSelected
        
        if(statusToggle.on){
        // set arm_disarm to true
            statusUpdate["arm_disarm"] = true;
            self.sensorStatus.text = "Armed"
            //set color
            self.sensorStatus.textColor = UIColor.greenColor()

        }
        
        else{
            statusUpdate["arm_disarm"] = false;
            self.sensorStatus.text = "Disarmed"
            self.sensorStatus.textColor = UIColor.redColor()
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
    
    @IBAction func backButton(sender: AnyObject) {
        SingletonB.sharedInstance.filteredDateIndices.removeAll(keepCapacity: false)
        SingletonB.sharedInstance.tableRowsBySelectedDay = 0
        SingletonB.sharedInstance.sensorLoggingDates.removeAll(keepCapacity: false)
    }
    

    //set number of rows in tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return SingletonB.sharedInstance.filteredDateIndices.count
    }
    
    // create cells for each row
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var index = SingletonB.sharedInstance.filteredDateIndices[indexPath.row]
        // create cell of homeCell type
        let cell:loggingCell = self.tableView.dequeueReusableCellWithIdentifier("loggingCell") as! loggingCell
        // return instance of cell
        cell.sensorName.text = sensorNameSet
        cell.eventTime.text = loggingTimes[index]
        cell.sensorEvent.text = eventSelector(loggingCodes[index])
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
                        if(self.sensorBatteryLevel == 0)
                        {
                            self.sensorBattery.image = UIImage(named: "Empty Battery-32.png")!
                        }
                            
                        else if (self.sensorBatteryLevel == 1)
                        {
                            self.sensorBattery.image = UIImage(named: "Low Battery-32-3.png")!
                        }
                            
                        else if (self.sensorBatteryLevel == 2)
                        {
                            self.sensorBattery.image = UIImage(named: "Half-Charged Battery-32.png")!
                        }
                            
                        else if (self.sensorBatteryLevel == 3)
                        {
                            self.sensorBattery.image = UIImage(named: "Charged Battery-32.png")!
                        }
                            
                        else if (self.sensorBatteryLevel == 4)
                        {
                            self.sensorBattery.image = UIImage(named: "Full Battery-32.png")!
                        }
                        
                        //set reception status
                        if(self.sensorReceptionLevel == 0)
                        {
                            self.sensorReception.image = UIImage(named: "Wi-Fi-32.png")!
                        }
                            
                        else if (self.sensorReceptionLevel == 1)
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
        

    
        var queryLogging = PFQuery(className:"logging");
        queryLogging.whereKey("sensorId", equalTo:sensorSelectionLoader)
        queryLogging.findObjectsInBackgroundWithBlock {
        (objects: [AnyObject]?, error: NSError?) -> Void in
    
            if error == nil {
            // The find succeeded.
            // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                    // intermediate variables to change datatype to string
                    let code = object["eventCode"] as! Int
                    var creation = object.createdAt!
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm"
                    let temp = dateFormatter.stringFromDate(creation)
                    let date = temp.substringWithRange(Range<String.Index>(start: temp.startIndex, end: advance(temp.endIndex, -6)))
                    let time = temp.substringWithRange(Range<String.Index>(start: advance(temp.startIndex, +11), end: temp.endIndex))
                    self.loggingCodes.append(code)
                    self.loggingDates.append(date)
                    SingletonB.sharedInstance.sensorLoggingDates.append(date)
                    self.loggingTimes.append(time)
                    }
                }
            } else {
            // Log details of the failure
            println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
    }
    
    func eventSelector(eventId: Int) -> String{
        
        if(eventId == 0){
            return "was disarmed"
        }
        
        else if(eventId == 1){
            return "was armed"
        }
        
        else if(eventId == 2){
            return "moved"
        }
        
        else if(eventId == 3){
            return "battery dropped to 10%"
        }
        
        else if(eventId == 4){
            return "had action taken: Escalate"
        }
        
        else if(eventId == 5){
            return "had action taken: Call"
        }
        
        else if(eventId == 6){
            return "had action taken: Text"
        }
        
        else if(eventId == 7){
            return "an alert was dismissed"
        }
        
        return "invalid event Id"
    }
    
    func reloadFunction(notification: NSNotification){
       tableView.reloadData()

    }
}




extension sensorDetails: CVCalendarViewDelegate {
    
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            
            let seconds = 1.0
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                var counter = 0
                SingletonB.sharedInstance.filteredDateIndices.removeAll(keepCapacity: false)
                let temp = dayView.date
                var tempTwo = self.calendarView.presentedDate.convertedDate()!
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
                var date = dateFormatter.stringFromDate(tempTwo)
                var filteredDates:[String] = []
            
                for item in SingletonB.sharedInstance.sensorLoggingDates{
                    if item  ==  date {
                        SingletonB.sharedInstance.filteredDateIndices.append(counter)
                    }
                    counter++
                }
            
                NSNotificationCenter.defaultCenter().postNotificationName("reloadTableView", object: nil)
            });
            
            return true
            
        }
        return false
    }
    
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        var counter = 0
        SingletonB.sharedInstance.filteredDateIndices.removeAll(keepCapacity: false)
        let temp = dayView.date
        var tempTwo = calendarView.presentedDate.convertedDate()!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        var date = dateFormatter.stringFromDate(tempTwo)
        var filteredDates:[String] = []
        
        for item in SingletonB.sharedInstance.sensorLoggingDates{
            if item  ==  date {
                SingletonB.sharedInstance.filteredDateIndices.append(counter)
            }
            counter++
        }
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableView", object: nil)
    }
}
extension sensorDetails: CVCalendarMenuViewDelegate {
    // firstWeekday() has been already implemented.
}


