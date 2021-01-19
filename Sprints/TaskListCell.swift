//
//  TaskListCell.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/18/21.
//

import UIKit
import DropDown

class TaskListCell: DropDownCell {

    @IBOutlet weak var nameField: UITextField!
//    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var timeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

