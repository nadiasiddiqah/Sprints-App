//
//  SprintTimeViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 12/28/20.
//

import Foundation
import UIKit
import CoreData

// SprintTimer class uses init method to initalize hour and minute values
class SprintTimer {
    var hour: String
    var minute: [String]
    
    init(hour: String, minute: [String]) {
        self.hour = hour
        self.minute = minute
    }
}

class SprintTimeViewController: UIViewController {
    
    @IBOutlet weak var sprintTimePicker: UIPickerView!
    
    // setSprintTimer intializes SprintTimer array
    var sprintTimer = [SprintTimer]()
    
    // timeSet saves user selected time
    var timeSet: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Connect picker view's dataSource and delegate to current view controller
        sprintTimePicker.dataSource = self
        sprintTimePicker.delegate = self
        
        // Append data to show in UIPickerView columns and rows
        sprintTimer.append(SprintTimer(hour: "0", minute: ["15", "30", "45"]))
        sprintTimer.append(SprintTimer(hour: "1", minute: ["00", "15", "30", "45"]))
        sprintTimer.append(SprintTimer(hour: "2", minute: ["00", "15", "30", "45"]))
        sprintTimer.append(SprintTimer(hour: "3", minute: ["00", "15", "30", "45"]))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let controller = segue.destination as? TaskListViewController {
//            controller.modalPresentationStyle = .fullScreen
//        }
    }
    
    @IBAction func nextButton() {
    }


}

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
            return sprintTimer.count
        } else {
            let setHour = sprintTimePicker.selectedRow(inComponent: 0)
            return sprintTimer[setHour].minute.count
        }
    }
    
    
}

// UIPickerViewDelegate creates views (ex: rows) to display data and respond to user selections
extension SprintTimeViewController: UIPickerViewDelegate {
    
    // Displays row content in each column
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if component == 0 {
            return sprintTimer[row].hour
        } else {
            let setHour = sprintTimePicker.selectedRow(inComponent: 0)
            return sprintTimer[setHour].minute[row]
        }
    }
    
    // Responds to user selecting a row in a column
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        sprintTimePicker.reloadComponent(1)
        
        let setHour = sprintTimePicker.selectedRow(inComponent: 0)
        let setMin = sprintTimePicker.selectedRow(inComponent: 1)
        let showHour = sprintTimer[setHour].hour
        let showMin = sprintTimer[setHour].minute[setMin]
        
        timeSet = "\(showHour + ":" + showMin)"
    }
    
}
