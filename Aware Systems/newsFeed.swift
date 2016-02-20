//
//  newsFeed.swift
//  Aware Systems
//
//  Created by Maxwell on 8/21/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit
import Parse

class newsFeed: UIViewController{
    
    
    var itemIndex: Int = 0
    var at = "@ "
    var sensorId: String = ""
    var hubName : String = "" {
        
        didSet {
            
            if let name = locationName {
                name.text =  at + hubName
            }
            
        }
    }
    
    var sensorName: String = "" {
        
        didSet {
            
            if let name = newsName {
                name.text = sensorName
            }
            
        }
    }
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var newsName: UILabel!

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newsName.text = sensorName
        self.locationName.text = at + hubName
        self.view.backgroundColor = UIColor.clearColor();

    }

    @IBAction func respondToNews(sender: AnyObject) {
        
        
        SingletonB.sharedInstance.sensorNamePayload = sensorName
        SingletonB.sharedInstance.sensorIdPayload = sensorId
        
       //change VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: sensorZoom = storyboard.instantiateViewControllerWithIdentifier("sensorZoom") as! sensorZoom
        
        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController
        UIApplication.sharedApplication().keyWindow!.makeKeyAndVisible()
        
       // performSegueWithIdentifier("newsToZoom", sender: self)
        
    }


}
