//
//  SprintTimeViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 12/28/20.
//

import Foundation
import UIKit

class SprintTimeViewController: UIViewController {
    
    @IBOutlet weak var sprintTimePicker: UIPickerView!
    
    // Picker view data
    let sprintTimeOptions = [["0", "1", "2", "3"], ["00", "15", "30", "45"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Connect picker view's dataSource and delegate to current view controller
        sprintTimePicker.dataSource = self
        sprintTimePicker.delegate = self
        
    }
    
    @IBAction func nextButton() {
    }


}

// Adopt picker data source to provide data to picker view
extension SprintTimeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return sprintTimeOptions[component].count
    }
    
    
}

// Adopt picker delegate to create views (ex: row) to display your data and respond to user selections
extension SprintTimeViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
       return sprintTimeOptions[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
    }
    
}
