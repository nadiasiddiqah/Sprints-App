//
//  TaskListViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 12/30/20.
//

import Foundation
import UIKit
import CoreData

// MARK: - TaskData struct
struct Task {
    var name, time: String
}

class TaskListViewController: UIViewController {
    
    // MARK: - Outlet Variables
    @IBOutlet weak var taskList: SelfSizedTableView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var addTaskButton: UIButton!
    
    // MARK: - Instance Variables
    var tasks = [Task]()
    
    var rowIndex = Int()
    
    var switchToSprintButton: Bool = false
    
    var currentTimeLeftInt = Int()
    var recentTaskTimeInt = Int()
    var clickedTaskTime = String()
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define max height for table view
        taskList.maxHeight = 351
        
        // Set initial taskTime value
        tasks.append(Task(name: "", time: "Set time"))
        currentTimeLeftInt = pickedTime
        
        // Connect table view's dataSource+delegate to current VC
        taskList.delegate = self
        taskList.dataSource = self
        
        // Update time labels on screen
        let time = showTimeLabel(time: pickedTime)
        totalTimeLabel.text = time
        timeLeftLabel.text = time

        // Hide keyboard on drag and tap
        taskList.keyboardDismissMode = .onDrag
        tapToHideKeyboard()
        
        // Add reset bar button
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain,
                                          target: self, action: #selector(resetSprint))
        navigationItem.leftBarButtonItem = resetButton
        navigationItem.hidesBackButton = true
    }
    
    // Segue to SprintTime screen
    @objc func resetSprint() {
        tasks.removeAll()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
//    // Segue to SelectTime or TaskRun screen
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueToSelectTime" {
//            let controller = segue.destination as! SelectTimeViewController
//
//            if switchToSprintButton {
//                // If time left == "0:00", subtract last set time
//                controller.switchToSprintButton = switchToSprintButton
//                if let task = taskTime[rowIndex] {
//                    clickedTaskTime = task
//                }
//                controller.clickedTaskTimeInt = showTimeInSec(time: clickedTaskTime)
//            } else {
//                // If there is more time left
//                controller.currentTimeLeftInt = currentTimeLeftInt
//            }
//        } else if segue.destination == TaskRunViewController() {
//
//        }
//    }
    
    // Unwind from SelectTimeVC
    @IBAction func unwindFromSelectTime(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! SelectTimeViewController
        tasks[rowIndex].time = controller.selectedTaskTime
//        checkTimeLeft()
        taskList.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
        print("row \(rowIndex): \(tasks[rowIndex].time)")
    }
    
    // MARK: - Helper Methods
    
    // Set up tap gesture recongizer on screen
    func tapToHideKeyboard() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Hides keyboard when screen is tapped
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // Checks if timeLeft is 0:00
//    func checkTimeLeft() {
//        let recentTaskTime = taskTime[rowIndex]
//        
//        if recentTaskTime != "Set time" {
//            // Convert recentTaskTime (Str) into Int
//            recentTaskTimeInt = showTimeInSec(time: recentTaskTime!)
//        }
//        
//        if currentTimeLeftInt == 0 {
//            updateTimeLeft()
//            showSprintButton()
//        } else if currentTimeLeftInt <= 900 {
//            updateTimeLeft()
//            showSprintButton()
//        } else if recentTaskTimeInt < currentTimeLeftInt {
//            updateTimeLeft()
//        } else if recentTaskTimeInt == currentTimeLeftInt {
//            updateTimeLeft()
//            showSprintButton()
//        } else {
//            updateTimeLeft()
//        }
//       
//    }
    
    func showSprintButton() {
        switchToSprintButton = true
        addTaskButton.setTitle("Ready, Set, Sprint!", for: .normal)
        addTaskButton.backgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.38, alpha: 1.00)
        
    }

//    func updateTimeLeft() {
//        // Filter out "Set time" from taskTime
//        var filterTaskTime = taskTime
//
//        for pair in filterTaskTime {
//            if pair.value == "Set time" {
//                filterTaskTime.removeValue(forKey: pair.key)
//            }
//        }
//
//        // Convert taskTime [Int:String] -> taskTimeInt [Int: Int]
//        let taskTimeInt = filterTaskTime.mapValues { (value) -> Int in
//            let components = value.split(separator: ":").map { (x) -> Int in
//                return Int(String(x))!
//            }
//            let valueInSec = (components[0]*60*60) + (components[1]*60)
//            return valueInSec
//        }
//
//        // Add together taskTimeInt
//        let addedTaskTime = taskTimeInt.values.reduce(0, +)
//
//        // Calculate timeLeft
//        currentTimeLeftInt = pickedTime - addedTaskTime
//
//        // Update timeLeftLabel
//        timeLeftLabel.text = showTimeLabel(time: currentTimeLeftInt)
//    }

    
    // MARK: - Action Methods
    
    @IBAction func pressedAddTask(_ sender: UIButton) {
        if switchToSprintButton {
            // Switch to Sprint Button to segue to TaskRun screen
            if let controller = storyboard?.instantiateViewController(identifier: "taskRunScreen") {
                view.endEditing(true)
                navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            // Adds new cell in Table View
            tasks.append(Task(name: "", time: "Set time"))
            taskList.reloadData()
            taskList.scrollToRow(at: IndexPath(row: tasks.count-1, section: 0), at: .bottom, animated: true)
        }
    }
    
}


// MARK: - UITableViewDataSource Extension
extension TaskListViewController: UITableViewDataSource {
    
    // Return the number of rows in table view
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // Return custom cell + data to show in table view
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        cell.delegate = self
        
        // Configure nameField and timeButton in taskCell
        let task = tasks[indexPath.row]
        
        cell.nameField.text = task.name
        cell.nameField.clearButtonMode = .always
        
        cell.timeButton.setTitle(task.time, for: .normal)
        if cell.timeButton.currentTitle == "Set time" {
            cell.timeButton.backgroundColor = UIColor.systemIndigo
        } else {
            cell.timeButton.backgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.38, alpha: 1.00)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive,
                                        title: "Delete") { [unowned self] (action, view, completionHandler) in
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }

}


// MARK: - UITableViewDelegate Extension
extension TaskListViewController: UITableViewDelegate {
    
    // De-selects a row after its selected
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: TaskCellDelegate Extension
extension TaskListViewController: TaskCellDelegate {
    func nameFieldDidBeginEditing(onCell cell: TaskCell) {
        cell.nameField.becomeFirstResponder()
    }
    
    func nameFieldDidEndEditing(onCell cell: TaskCell) {
        if let indexPath = taskList.indexPath(for: cell) {
            rowIndex = indexPath.row
            if let newName = cell.nameField.text {
                tasks[rowIndex].name = newName
                print("row \(rowIndex): \(newName)")
            }
        }
        cell.nameField.resignFirstResponder()
    }
    
    func nameFieldShouldReturn(onCell cell: TaskCell) -> Bool {
        cell.nameField.resignFirstResponder()
        return true
    }
    
    func pressedTimeButton(onCell cell: TaskCell) {
        if let indexPath = taskList.indexPath(for: cell) {
            rowIndex = indexPath.row
            print("row \(rowIndex): button tapped")
        }
    }

}
