//
//  SprintTimeViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 12/28/20.
//

import Foundation
import UIKit
import CoreData

// MARK: - TimerData Class

// Custom class type to set hour/min options in UIPickerView
public class TimerData {
    var hour: String
    var minute: [String]
    
    init(hour: String, minute: [String]) {
        self.hour = hour
        self.minute = minute
    }
}

// MARK: - SprintTimeViewController Class
class SprintTimeViewController: UIViewController {
    
    // MARK: - Outlet Variables
    @IBOutlet weak var sprintTimePicker: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    // MARK: - Instance Variables
    
    // Creates an empty array of TimerData class type
    var timerData = [TimerData]()
    
    // Saves user selected time
    var tempTimerSet: [String] = ["0", "00", "00"]

    // Reference to Managed Object Context (via the Persistent Container in AppDelegate)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
        timerData.append(TimerData(hour: "0", minute: ["00", "15", "30", "45"]))
        timerData.append(TimerData(hour: "1", minute: ["00", "15", "30", "45"]))
        timerData.append(TimerData(hour: "2", minute: ["00", "15", "30", "45"]))
        timerData.append(TimerData(hour: "3", minute: ["00", "15", "30", "45"]))
        
    }
    
    // Runs before view appeas
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // Runs before view disappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // Runs before segue to next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTaskList" {
            let controller = segue.destination as! TaskListViewController
            controller.context = context
            controller.savedTotalTime = tempTimerSet
        }
    }
    
    // MARK: - Action Methods
    
    // Runs when nextButton is pressed
    @IBAction func pressedNext() {
        saveTimerSet()
    }
    
    // MARK: - Methods
    
    // Save timer set by user data in Core Data
    func saveTimerSet() {
        // Create SprintTimer object (using timer set by user data)
        let finalTimerSet = SprintTimer(context: self.context)
        finalTimerSet.hour = tempTimerSet[0]
        finalTimerSet.min = tempTimerSet[1]
        finalTimerSet.sec = tempTimerSet[2]
        
        // Add error handling if saving fails
        do {
            // Save the timer set by user data
            try self.context.save()
            // DEBUG: issues with finalTimerSet data
            print(finalTimerSet)
        } catch {
            // Show error alert to user
            let alert = UIAlertController(title: "Fatal Error", message: "Unable to save timer set", preferredStyle: .alert)
            let action = UIAlertAction(title: "Force Quit", style: .destructive, handler: nil)
            alert.addAction(action)
            present(alert, animated: true) {
                DispatchQueue.main.async {
                    fatalError()
                }
            }
            // DEBUG: error in saving timer set by user data
            print(error.localizedDescription)
        }
    }
    
    // Determines if next button is enabled
    func enableNextButton() {
        if tempTimerSet != ["0", "00", "00"] {
            // Animate enabling next button
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                self.nextButton.alpha = 1
            } completion: { _ in
                self.nextButton.isEnabled = true
            }
        } else if tempTimerSet == ["0", "00", "00"] {
            // Animate disabling next button
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                self.nextButton.alpha = 0.4
            } completion: { _ in
                self.nextButton.isEnabled = false
            }
        }
    }
}

// MARK: - UIPickerViewDataSource protocol

// UIPickerDataSource provides data to UIPickerView
extension SprintTimeViewController: UIPickerViewDataSource {

    // MARK: - UIPickerViewDataSource protocol methods
    
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
    
    // MARK: - UIPickerViewDelegate protocol methods
    
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
        let hour = timerData[selectedHour].hour
        let min = timerData[selectedHour].minute[selectedMin]
        let sec: String = "00"

        tempTimerSet = ["\(hour)", "\(min)", "\(sec)"]
        
        enableNextButton()
        
        print(tempTimerSet)
        
    }
    
}
