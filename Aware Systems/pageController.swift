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
        
        if itemIndex < sensorNames.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("newsFeed") as! newsFeed
            pageItemController.itemIndex = itemIndex
            pageItemController.sensorId = sensorIds[itemIndex]
            pageItemController.sensorName = sensorNames[itemIndex]
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
            self.dataQueryInSensors(self.sensorIds, numberOfSensors: self.sensorIds.count )
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
