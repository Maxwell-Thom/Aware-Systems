//
//  homeCell.swift
//  Aware Systems
//
//  Created by Maxwell on 6/9/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit

class homeCell: UITableViewCell {
    //declare variables (give these variables better names! they are used in both sensors and hubs)
    @IBOutlet weak var hubName: UILabel!
    
    @IBOutlet weak var hubStatus: UILabel!

    @IBOutlet weak var sensorReception: UIImageView!
    
    @IBOutlet weak var sensorBattery: UIImageView!
}
