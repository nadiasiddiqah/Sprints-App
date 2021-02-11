//
//  TaskRunCell.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 2/5/21.
//

import UIKit

protocol TaskRunCellDelegate: class {
    func pressedNextTaskButton(onCell cell: TaskRunCell)
}

class TaskRunCell: UITableViewCell {
    
    // MARK: - Instance Variables
    weak var delegate: TaskRunCellDelegate?

    // MARK: - Outlet Variables
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var nextTaskButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if taskCount < 2 {
            nextTaskButton.setTitle("Complete", for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - TaskRunCellDelegate Methods
    
    @IBAction func pressedNext(_ sender: Any) {
        delegate?.pressedNextTaskButton(onCell: self)
    }
    
}
