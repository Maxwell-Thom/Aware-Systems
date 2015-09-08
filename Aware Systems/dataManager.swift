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
    var newsName: String = ""
    
    //these variables are strictly for populating the log from the calendar
    var sensorLoggingDates: [String] = []
    var tableRowsBySelectedDay: Int = 0
    var filteredDateIndices: [Int] = []
    //var sensor
    class var sharedInstance : SingletonB {
        struct Static {
            static let instance : SingletonB = SingletonB()
        }
        
        return Static.instance
    }
}
