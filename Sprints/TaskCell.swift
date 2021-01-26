//
//  TaskCell.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/25/21.
//

import UIKit

class TaskCell: UITableViewCell {

    // MARK: - Outlet Variables
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var timeButton: UIButton!
    
//    var indexPath: IndexPath?
    
    // MARK: - Helper Methods
    
    
    
//    @objc func showSelectTime(_ sender: UIButton) {
//        performSegue(withIdentifier: "selectTime", sender: nil)
//    }
    
    
    // MARK: - Table View Cell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        if timeButton.isSelected {
//            timeButton.addTarget(self, action: #selector(showSelectTime(_:)), for: .touchUpInside)
//        }

        // Configure the view for the selected state
    }

}
