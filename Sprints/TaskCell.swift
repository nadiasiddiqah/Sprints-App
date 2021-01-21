//
//  TaskCell.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/20/21.
//

import UIKit


class TaskListCell: UITableViewCell {

    @IBOutlet weak var nameField: UITextField!
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
