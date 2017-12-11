//
//  WorkoutTableViewCell.swift
//  Optimal Living
//
//  Created by Chris Frerichs on 12/8/17.
//  Copyright © 2017 Chris Frerichs. All rights reserved.
//

import Foundation
import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var workPeriodLabel: UILabel!
    @IBOutlet weak var restPeriodLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
