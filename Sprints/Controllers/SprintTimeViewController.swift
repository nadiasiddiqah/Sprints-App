//
//  SprintTimeViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 12/28/20.
//

import Foundation
import UIKit

// MARK: - SprintTimeViewController Class
class SprintTimeViewController: UIViewController {
    
    // MARK: - Outlet Variables
    @IBOutlet weak var sprintTimePicker: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Instance Variables
    
    // Creates an empty array of TimerData class type
    var timerData = [TimePickerData]()
    
    // MARK: - View Controller Methods
    
    // Runs when view loads
    override func viewDidLoad() {
        super.viewDidLoad()

        // Connect picker view's dataSource and delegate to current view controller
        sprintTimePicker.dataSource = self
        sprintTimePicker.delegate = self
        
        // Disable next button
        nextButton.alpha = 0
        nextButton.isEnabled = false
        
        // Append data to show in UIPickerView columns
        timerData.append(TimePickerData(hour: "0", minute: ["00", "15", "30", "45"]))
        timerData.append(TimePickerData(hour: "1", minute: ["00", "15", "30", "45"]))
        timerData.append(TimePickerData(hour: "2", minute: ["00", "15", "30", "45"]))
        timerData.append(TimePickerData(hour: "3", minute: ["00", "15", "30", "45"]))
        
    }
    
    // Runs before view appeas
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        Utils.showGradientLayer(view: view)
    }
    
    // Runs before view disappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Action Methods
    
    // Saves pickedTime to Core Data
    @IBAction func pressedNext(_ sender: UIButton) {
        Utils.buttonSpringAction(button: nextButton,
                                 selectedColor: Utils.lavender, normalColor: UIColor.systemIndigo,
                                 pressDownTime: 0.2, normalTime: 0.25) {
            self.performSegue(withIdentifier: "segueToTaskList", sender: nil)
        }
    }
    
    // MARK: - Methods
    
    // Determines if next button is enabled
    func enableNextButton() {
        if Utils.pickedTime != 0 {
            // Enable next button
            Utils.buttonEnabling(button: nextButton, enable: true)
        } else if Utils.pickedTime == 0 {
            // Disable next button
            Utils.buttonEnabling(button: nextButton, enable: false)
        }
    }
    
}

// MARK: - UIPickerViewDataSource protocol
// UIPickerDataSource provides data to UIPickerView
extension SprintTimeViewController: UIPickerViewDataSource {
    
    // Displays number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // Displays number of rows in each column
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return timerData.count
        } else {
            let setHour = sprintTimePicker.selectedRow(inComponent: 0)
            return timerData[setHour].minute.count
        }
    }
    
}

// MARK: - UIPickerViewDelegate protocol
// UIPickerViewDelegate creates views (ex: rows) to display data and respond to user selections
extension SprintTimeViewController: UIPickerViewDelegate {
    
    // Displays row content in each column
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        if component == 0 {
            return timerData[row].hour
        } else {
            let setHour = sprintTimePicker.selectedRow(inComponent: 0)
            return timerData[setHour].minute[row]
        }
    }
    
    // Responds to user selecting a row in a column
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {

        let selectedHour = sprintTimePicker.selectedRow(inComponent: 0)
        let selectedMin = sprintTimePicker.selectedRow(inComponent: 1)
        let hourInSec = Int(timerData[selectedHour].hour)! * 60 * 60
        let minInSec = Int(timerData[selectedHour].minute[selectedMin])! * 60

        Utils.pickedTime = hourInSec + minInSec
        
        enableNextButton()
    }
    
}
