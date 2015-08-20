//
//  dataManager.swift
//  Aware Systems
//
//  Created by Maxwell on 6/23/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import Foundation

class SingletonB {
    
    var sensorNamePayload: String = ""
    var sensorIdPayload = ""
    var hubSelected: String = ""
    var sensorSelected: String = ""
    
    class var sharedInstance : SingletonB {
        struct Static {
            static let instance : SingletonB = SingletonB()
        }
        
        return Static.instance
    }
}
