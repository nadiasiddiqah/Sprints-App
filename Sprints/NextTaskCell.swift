//
//  NextTaskCell.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 2/6/21.
//

import UIKit

class NextTaskCell: UITableViewCell {
    
    @IBOutlet weak var nextTaskName: UILabel!
    @IBOutlet weak var nextTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
