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
    @IBOutlet weak var pickedTimeLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var addOrSprintButton: UIButton!
    @IBOutlet weak var taskListStack: UIStackView!
    
    // MARK: - Instance Variables
    
    // Updates with indexPath.row of clicked timeButton
    var rowIndex = Int()
    
    // Updates timeLeft when new time is set
    var timeLeft = Int()
    
    var switchToSprintButton: Bool = false
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define max height for table view
        taskList.maxHeight = 351
        
        // Set initial taskTime value
        tasks.append(Task(name: "", time: "Set time"))
        timeLeft = pickedTime
        
        // Connect table view's dataSource+delegate to current VC
        taskList.delegate = self
        taskList.dataSource = self
        
        // Update time labels on screen
        let time = showTimeLabel(time: pickedTime)
        pickedTimeLabel.text = time
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue to SelectTime
        if segue.identifier == "segueToSelectTime" {
            let controller = segue.destination as! SelectTimeViewController
            
            if tasks[rowIndex].time == "Set time" {
                // Initially set timeButton title
                controller.timeLeft = timeLeft
                print("setting time in row \(rowIndex)")
            } else if tasks[rowIndex].time != "Set time" {
                // Edit timeButton title
                tasks[rowIndex].time = "0:00"
                updateTimeLeft()
                controller.timeLeft = timeLeft
                print("editing time in row \(rowIndex)")
            }
        } else {
            // Segue to TaskRun
            performSegue(withIdentifier: "segueToTaskRun", sender: nil)
        }
    }
    
    // Unwind from SelectTimeVC
    @IBAction func unwindFromSelectTime(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! SelectTimeViewController
        tasks[rowIndex].time = controller.selectedTaskTimeLabel
        updateTimeLeft()
        taskList.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
        print(tasks)
    }
    
    // MARK: - Helper Methods
    
    // Segue to SprintTime screen
    @objc func resetSprint() {
        tasks.removeAll()
        navigationController?.popViewController(animated: true)
    }
    
    // Set up tap gesture recongizer on screen
    func tapToHideKeyboard() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Hides keyboard when screen is tapped
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    func updateTimeLeft() {
        var updatedTaskTimes = [Int]()
        
        for task in tasks {
            // Filter out "set time" from task.time
            if task.time != "Set time" {
                // Convert task.time (Str) to Int
                let timeInSec = showTimeInSec(time: task.time)
                updatedTaskTimes.append(timeInSec)
            }
        }
        
        // Update currentTimeLabel
        timeLeft = pickedTime - updatedTaskTimes.reduce(0, +)
        timeLeftLabel.text = showTimeLabel(time: timeLeft)
        
        // Check timeLeft and initiate appropriate action
        checkTaskInfo()
    }
    
    // Check timeLeft and initiate appropriate action
    func checkTaskInfo() {
        var checkTaskNames = [String]()
        var checkTaskTimes = [String]()
        
        if timeLeft == 0 {
            // When timeLeft = 0, show sprint button
            showSprintButton()
            
            // Compile taskName and taskTime values
            for task in tasks {
                checkTaskNames.append(task.name)
                checkTaskTimes.append(task.time)
            }
            
            // Check if taskName or taskTime is empty, show appropriate alert + buttonAnimation
            if checkTaskNames.contains("") || checkTaskTimes.contains("Set time") {
                buttonAnimation(button: addOrSprintButton, enable: false)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
//                    let alert = UIAlertController(title: "Finish updating task name and time to start the sprint.", message: nil, preferredStyle: .alert)
//                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alert.addAction(action)
//                    present(alert, animated: true, completion: nil)
//                }
            } else {
                buttonAnimation(button: addOrSprintButton, enable: true)
            }
        } else {
            // When timeLeft > 0, show add button
            showAddButton()
            buttonAnimation(button: addOrSprintButton, enable: true)
        }
    }
    
    func showAddButton() {
        switchToSprintButton = false
        addOrSprintButton.setTitle("➕ Add Task", for: .normal)
        addOrSprintButton.backgroundColor = UIColor.systemIndigo
    }
    
    func showSprintButton() {
        switchToSprintButton = true
        addOrSprintButton.setTitle("Ready, Set, Sprint!", for: .normal)
        addOrSprintButton.backgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.38, alpha: 1.00)
    }
    

    
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
        
        updateTimeLeft()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive,
                                        title: "Delete") { [unowned self] (action, view, completionHandler) in
            // Update tasks data + current time label
            tasks.remove(at: indexPath.row)
            updateTimeLeft()
            
            // Update tableView
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Update tableView + button positioning
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: tasks.count-1, section: 0), at: .bottom, animated: true)
            
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
            if let newName = cell.nameField.text {
                tasks[indexPath.row].name = newName
            }
        }
        updateTimeLeft()
        view.endEditing(true)
    }
    
    func nameFieldShouldReturn(onCell cell: TaskCell) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func pressedTimeButton(onCell cell: TaskCell) {
        view.endEditing(true)
        if let indexPath = taskList.indexPath(for: cell) {
            rowIndex = indexPath.row
            performSegue(withIdentifier: "segueToSelectTime", sender: nil)
        }
    }

}
