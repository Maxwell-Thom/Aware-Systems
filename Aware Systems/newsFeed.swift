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
    
    var sensorId: String = ""
    
    var sensorName: String = "" {
        
        didSet {
            
            if let name = newsName {
                name.text = sensorName
            }
            
        }
    }
    
    @IBOutlet weak var newsName: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newsName.text = sensorName


    }

    @IBAction func respondToNews(sender: AnyObject) {
        
        
        SingletonB.sharedInstance.sensorNamePayload = sensorName
        SingletonB.sharedInstance.sensorIdPayload = sensorId
        
        //change VC
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: sensorZoom = storyboard.instantiateViewControllerWithIdentifier("sensorZoom") as! sensorZoom
        
        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController
        UIApplication.sharedApplication().keyWindow!.makeKeyAndVisible()
        
    }


}
