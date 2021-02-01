//
//  TaskCell.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/25/21.
//

import UIKit

protocol TaskCellDelegate: class {
    func pressedTimeButton(onCell cell: TaskCell)
    func nameFieldDidEndEditing(onCell cell: TaskCell)
    func nameFieldShouldReturn(onCell cell: TaskCell) -> Bool
}

class TaskCell: UITableViewCell, UITextFieldDelegate {

    // MARK: - Instance Variables
    weak var delegate: TaskCellDelegate?
    
    // MARK: - Outlet Variables
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var timeButton: UIButton!
    
    // MARK: - Table View Cell Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - TaskCellDelegate Methods
    @IBAction func tapTimeButton(_ sender: UIButton) {
        delegate?.pressedTimeButton(onCell: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.nameFieldDidEndEditing(onCell: self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.nameFieldShouldReturn(onCell: self)
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Helper Methods
    

}


