//
//  pageController.swift
//  Aware Systems
//
//  Created by Maxwell on 8/23/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit
import Parse

class pageController: UIViewController, UIPageViewControllerDataSource {
    
     private var pageViewController: UIPageViewController?
    
    var sensorIds :[String] = []
    var sensorNames :[String] = []
    var hubDescription : [String] = []
    var hubRelations : [NSArray] = []
    
    
    override func viewDidLoad() {
    
        dataQueryInNews()
        
    }
    
    func intiliazePageController(){
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.view.frame = self.view.frame;
        pageController.dataSource = self

        if sensorNames.count > 0 {
            let firstController = getItemController(0)!
            let startingViewController: NSArray = [firstController]
            pageController.setViewControllers(startingViewController as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        if sensorNames.count == 0 {
            let firstController = self.storyboard!.instantiateViewControllerWithIdentifier("noNews") as! noNews
            let startingViewController: NSArray = [firstController]
            pageController.setViewControllers(startingViewController as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)

    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if(sensorNames.count == 0)
        {
            return nil
        }
        
        let itemController = viewController as! newsFeed
        
        if itemController.itemIndex+1 < sensorNames.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if(sensorNames.count == 0)
        {
            return nil
        }
        
        let itemController = viewController as! newsFeed
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
        
    }
    
    private func getItemController(itemIndex: Int) -> newsFeed? {
        
        var counter = 0
        var hubName = ""
        
        if itemIndex < sensorNames.count {

            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("newsFeed") as! newsFeed
            pageItemController.itemIndex = itemIndex
            pageItemController.sensorId = sensorIds[itemIndex]
            pageItemController.sensorName = sensorNames[itemIndex]
            
            while(counter < hubDescription.count){
                
                if(self.hubRelations[counter].containsObject(sensorIds[itemIndex])){
                    hubName = hubDescription[counter]
                    counter = hubDescription.count
                }
                    
                else{
                    counter++
                }
            }
            
            pageItemController.hubName = hubName
            pageItemController.view.frame = self.view.frame;
            return pageItemController
        }
        
        return nil
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.sensorNames.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    func dataQueryInNews(){
        
        var queryNews = PFQuery(className: "news")
        
        queryNews.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var sensors = object["sensorId"] as! String
                        self.sensorIds.append(sensors)
                    }
                }
            }
            self.dataQueryInhubs()
            self.dataQueryInSensors(self.sensorIds, numberOfSensors: self.sensorIds.count )
        }
    }
    
    func dataQueryInhubs(){
        var counter = 0;
        var queryNews = PFQuery(className: "hubs")
        
        queryNews.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var relations = object["Sensors"] as! NSArray
                        var description = object["hub_description"] as! String
                        self.hubRelations.append(relations.valueForKey("objectId")! as! NSArray)
                        self.hubDescription.append(description)
                    }
                    
                }
            }
        }
    }
    
    func dataQueryInSensors(sensorId:[String], numberOfSensors:Int){
        var querySensors = PFQuery(className: "sensors")
        var counter = 0;
        while(counter < numberOfSensors){
            querySensors.whereKey("objectId", equalTo: sensorId[counter])
            
            var objects = querySensors.findObjects() as! [PFObject]
            
            for object in objects {
                var names = object["sensor_description"] as! String
                self.sensorNames.append(names)
                
            }
            counter = counter+1
        }
        //createViewControllers()
        intiliazePageController()
        setupPageControl()
    }
}
