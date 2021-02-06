//
//  TaskRunCell.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 2/5/21.
//

import UIKit

class TaskRunCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskTimerLabel: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var nextTaskButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
