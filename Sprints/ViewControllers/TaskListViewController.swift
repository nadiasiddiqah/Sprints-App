//
//  TaskListViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 12/30/20.
//

import Foundation
import UIKit
import CoreData

// MARK: - TimerData Class

// Custom class type to set task name/time in UITableView
public class TaskData {
    var name: String
    var time: String
    
    init(name: String, time: String) {
        self.name = name
        self.time = time
    }
}

class TaskListViewController: UIViewController {
    
    // MARK: - Outlet Variables
    @IBOutlet weak var taskList: SelfSizedTableView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var addTaskButton: UIButton!
    
    // MARK: - Instance Variables
    
    // Reference to Managed Object Context (via the Persistent Container in AppDelegate)
//    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
//    var taskData = [TaskData]()
    
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
        taskTime[0] = "Set time"
        currentTimeLeftInt = pickedTime
        
        // Connect table view's dataSource and delegate to current view controller
        taskList.delegate = self
        taskList.dataSource = self
        
        // Update time labels on screen
        let time = showTimeLabel(time: pickedTime)
        totalTimeLabel.text = time
        timeLeftLabel.text = time

        // Hide keyboard on drag and tap
        taskList.keyboardDismissMode = .onDrag
        setUpGestureRecognizer()
        
//        fetchTotalTime()
    }
    
//    func fetchTotalTime() {
//        do {
//            totalTime = try context.fetch(TotalTime.fetchRequest())
//
//            let hour = Int(totalTime) / 60 / 60
//            let min = (totalTime - (hour * 60 * 60)) / 60
//
//            totalTimeLabel.text = String(format: "%01d:%02d", hour, min)
//            timeLeftLabel.text = String(format: "%01d:%02d", hour, min)
//        } catch {
//            // Show error alert to user
//            let alert = UIAlertController(title: "Fatal Error", message: "Unable to save timer set", preferredStyle: .alert)
//            let action = UIAlertAction(title: "Force Quit", style: .destructive, handler: nil)
//            alert.addAction(action)
//            present(alert, animated: true) {
//                DispatchQueue.main.async {
//                    fatalError()
//                }
//            }
//            // DEBUG if error in saving pickedTime
//            print(error.localizedDescription)
//        }
//    }
    
    
    // MARK: - Navigation
    
    // Segue to SelectTimeVC or TaskRunVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSelectTime" {
            let controller = segue.destination as! SelectTimeViewController
            
            if switchToSprintButton {
                // If time left == "0:00", subtract last set time
                controller.switchToSprintButton = switchToSprintButton
                if let task = taskTime[rowIndex] {
                    clickedTaskTime = task
                }
                let components = clickedTaskTime.split(separator: ":").map { (x) -> Int in
                    return Int(String(x))!
                }
                controller.clickedTaskTimeInt = (components[0]*60*60) + (components[1]*60)
            } else {
                // If time left != "0:00"
                controller.currentTimeLeftInt = currentTimeLeftInt
            }
        } else if segue.destination == TaskRunViewController() {
    
        }
    }
    
    // Unwind from SelectTimeVC
    @IBAction func unwindFromSelectTime(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! SelectTimeViewController
        taskTime[rowIndex] = controller.selectedTaskTime
        checkTimeLeft()
        taskList.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
        print(taskTime)
    }
    
    // MARK: - Helper Methods
    
    // Set up tap gesture recongizer on screen
    func setUpGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Hides keyboard when screen is tapped
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // Checks if timeLeft is 0:00
    func checkTimeLeft() {
        let recentTaskTime = taskTime[rowIndex]
        
        if recentTaskTime != "Set time" {
            // Convert recentTaskTime (Str) into Int
            let recentTimeComponents = recentTaskTime?.split { $0 == ":" }.map({ (x) -> Int in
                Int(String(x))!
            })

            if let components = recentTimeComponents {
               recentTaskTimeInt = (components[0] * 60 * 60) + (components[1] * 60)
            }
        }
        
        if currentTimeLeftInt == 0 {
            updateTimeLeft()
            showSprintButton()
        } else if currentTimeLeftInt <= 900 {
            updateTimeLeft()
            showSprintButton()
        } else if recentTaskTimeInt < currentTimeLeftInt {
            updateTimeLeft()
        } else if recentTaskTimeInt == currentTimeLeftInt {
            updateTimeLeft()
            showSprintButton()
        } else {
            updateTimeLeft()
        }
       
    }
    
    func showSprintButton() {
        switchToSprintButton = true
        addTaskButton.setTitle("Ready, Set, Sprint!", for: .normal)
        addTaskButton.backgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.38, alpha: 1.00)
    }

    func updateTimeLeft() {

        // Filter out "Set time" from taskTime
        var filterTaskTime = taskTime
        
        for pair in filterTaskTime {
            if pair.value == "Set time" {
                filterTaskTime.removeValue(forKey: pair.key)
            }
        }
        
        // Convert taskTime [Int:String] -> taskTimeInt [Int: Int]
        let taskTimeInt = filterTaskTime.mapValues { (value) -> Int in
            let components = value.split(separator: ":").map { (x) -> Int in
                return Int(String(x))!
            }
            let valueInSec = (components[0]*60*60) + (components[1]*60)
            return valueInSec
        }
        
        // Add together taskTimeInt
        let addedTaskTime = taskTimeInt.values.reduce(0, +)
        
        // Calculate timeLeft
        currentTimeLeftInt = pickedTime - addedTaskTime
        
        // Update timeLeftLabel
        timeLeftLabel.text = showTimeLabel(time: currentTimeLeftInt)
    }

    
    // MARK: - Action Methods
    
    @IBAction func pressedAddTask(_ sender: UIButton) {
        if switchToSprintButton {
            // Switch to Sprint Button to segue to TaskRun screen
            if let controller = storyboard?.instantiateViewController(identifier: "taskRunScreen") {
                view.endEditing(true)
                navigationController?.pushViewController(controller, animated: true)
                print(taskName)
                print(taskTime)
            }
        } else {
            // Adds new cell in Table View
            taskCount += 1
            taskTime[taskCount-1] = "Set time"
            taskList.reloadData()
            taskList.scrollToRow(at: IndexPath(row: taskCount-1, section: 0), at: .bottom, animated: true)
        }
    }
    
    
}


// MARK: - UITableViewDataSource Extension
extension TaskListViewController: UITableViewDataSource {
    
    // Return the number of rows in table view
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return taskCount
    }
    
    // Return the cell to the insert in table view
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        cell.delegate = self
        
        // Configure nameField in taskCell
        cell.nameField.text = taskName[indexPath.row]
        cell.nameField.clearButtonMode = .always
        
        // Configure timeButton in taskCell
        cell.timeButton.setTitle(taskTime[indexPath.row], for: .normal)
        
        if cell.timeButton.currentTitle != "Set time" {
            cell.timeButton.backgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.38, alpha: 1.00)
        } else {
            cell.timeButton.setTitle("Set time", for: .normal)
            cell.timeButton.backgroundColor = UIColor.systemIndigo
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView,
//                   commit editingStyle: UITableViewCell.EditingStyle,
//                   forRowAt indexPath: IndexPath) {
//        taskName[indexPath.row] = nil
//        taskTime[indexPath.row] = nil
//
//        taskCount -= 1
//        taskList.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
//        taskList.reloadData()
//    }
    
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
            taskName[rowIndex] = cell.nameField.text
            print("Task edited on row \(indexPath.row)")
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
            print("Button tapped on row \(indexPath.row)")
        }
    }

}

