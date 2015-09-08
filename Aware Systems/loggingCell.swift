//
//  loggingCell.swift
//  Aware Systems
//
//  Created by Maxwell on 9/8/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit

class loggingCell: UITableViewCell {

    @IBOutlet weak var sensorName: UILabel!
    @IBOutlet weak var sensorEvent: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
