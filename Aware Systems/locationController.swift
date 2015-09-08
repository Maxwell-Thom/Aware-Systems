//
//  locationController.swift
//  Aware Systems
//
//  Created by Maxwell on 8/16/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit
import Parse

class locationController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerData:[String] = []
    var selectedHub: [String] = []
    var status: [Bool] = []
    
    @IBOutlet weak var hubStatus: UILabel!
    @IBOutlet weak var locationPicker: UIPickerView!
    
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
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    // do something to each object in objects
                    for object in objects {
                        // intermediate variables to change datatype to string
                        let description = object["hub_description"] as! String
                        let status = object["hub_status"] as! Bool
                        let hubId = object.objectId
                        //put variables into arrays
                        //self.hubStatus.append(status)
                        self.pickerData.append(description)
                        self.status.append(status)
                        self.selectedHub.append(hubId!)
                        self.locationPicker.reloadAllComponents()
                        SingletonB.sharedInstance.hubSelected = self.selectedHub[0]
                        if(self.status[0] == true){
                            self.hubStatus.text = "Online"
                            self.hubStatus.textColor = UIColor( red: 0/255, green: 142/255, blue:65/255, alpha: 1.0 )
                        }
                        else if (self.status[0] == false){
                            self.hubStatus.text = "Offline"
                            self.hubStatus.textColor = UIColor.redColor()
                        }
                        self.parentViewController?.viewDidLoad()
                    }
                }
            }
                
            else {
                // Log details of the failure
                //println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
       
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row] as String
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        let pickerLabel = UILabel()
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Avenir Next Medium", size: 26.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        pickerLabel.attributedText = myTitle
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        SingletonB.sharedInstance.hubSelected = self.selectedHub[row] as String
        self.parentViewController?.viewDidLoad()
        
        if(self.status[row] == true){
            self.hubStatus.text = "Online"
            self.hubStatus.textColor = UIColor( red: 24/255, green: 166/255, blue:79/255, alpha: 1.0 )
        }
        else if (self.status[row] == false){
            self.hubStatus.text = "Offline"
            self.hubStatus.textColor = UIColor.redColor()
        }
    }
 

}
