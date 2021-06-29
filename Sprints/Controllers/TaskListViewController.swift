//
//  TaskListViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 12/30/20.
//

import Foundation
import UIKit

class TaskListViewController: UIViewController {
    
    // MARK: - Outlet Variables
    @IBOutlet weak var taskList: SelfSizedTableView! {
        didSet {
            taskList.maxHeight = 351
        }
    }
    @IBOutlet weak var progressBar: UIProgressView! {
        didSet {
            progressBar.progressTintColor = Utils.green
        }
    }
    @IBOutlet weak var pickedTimeLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var addOrSprintButton: UIButton!
    @IBOutlet weak var taskListStack: UIStackView!
    
    // MARK: - Instance Variables
    
    // Updates with indexPath.row of clicked timeButton
    var rowIndex = Int()
    
    // Updates timeLeft when new time is set
    var timeLeft = Int()
    
    var switchToSprintButton = false
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial taskTime value
        Utils.tasks.append(Task(name: "", time: "Set time"))
        timeLeft = Utils.pickedTime
        
        // Connect table view's dataSource+delegate to current VC
        taskList.delegate = self
        taskList.dataSource = self
        
        // Update time labels on screen
        let time = Utils.showTimeLabel(time: Utils.pickedTime)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utils.showGradientLayer(view: view)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSelectTime" {
            // Segue to SelectTime
            let controller = segue.destination as! SelectTimeViewController
            
            if Utils.tasks[rowIndex].time == "Set time" {
                // Initially set timeButton title
                controller.timeLeft = timeLeft
            } else if Utils.tasks[rowIndex].time != "Set time" {
                // Edit timeButton title
                Utils.tasks[rowIndex].time = "0:00"
                updateTimeLeft()
                controller.timeLeft = timeLeft
            }
        } else {
            // Segue to TaskRun
            performSegue(withIdentifier: "segueToTaskRun", sender: nil)
        }
    }
    
    // Unwind from SelectTimeVC
    @IBAction func unwindFromSelectTime(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! SelectTimeViewController
        Utils.tasks[rowIndex].time = controller.selectedTaskTimeLabel
        updateTimeLeft()
        taskList.reloadData()
        print(Utils.tasks)
    }
    
    // MARK: - Helper Methods
    
    // Segue to SprintTime screen
    @objc func resetSprint() {
        view.endEditing(true)
        Utils.tasks.removeAll()
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
        
        for task in Utils.tasks {
            // Filter out "set time" from task.time
            if task.time != "Set time" {
                // Convert task.time (Str) to Int
                let timeInSec = Utils.showTimeInSec(time: task.time)
                updatedTaskTimes.append(timeInSec)
            }
        }
        
        // Update timeLeft
        timeLeft = Utils.pickedTime - updatedTaskTimes.reduce(0, +)
        timeLeftLabel.text = Utils.showTimeLabel(time: timeLeft)
        
        // Update progressBar
        progressBar.progress = Float(Utils.pickedTime-timeLeft)/Float(Utils.pickedTime)

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
            for task in Utils.tasks {
                checkTaskNames.append(task.name)
                checkTaskTimes.append(task.time)
            }
            
            // Check if taskName or taskTime is empty, show appropriate buttonAnimation
            if checkTaskNames.contains("") || checkTaskTimes.contains("Set time") {
                Utils.buttonEnabling(button: addOrSprintButton, enable: false)
            } else {
                Utils.buttonEnabling(button: addOrSprintButton, enable: true)
            }
        } else {
            // When timeLeft > 0, show add button
            showAddButton()
            Utils.buttonEnabling(button: addOrSprintButton, enable: true)
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
        addOrSprintButton.backgroundColor = Utils.green
    }
    

    // MARK: - Action Methods
    
    @IBAction func pressedAddTask(_ sender: UIButton) {
        if switchToSprintButton {
            // Switch to Sprint Button to segue to TaskRun screen
            Utils.buttonSpringAction(button: addOrSprintButton,
                                     selectedColor: Utils.teal, normalColor: Utils.green,
                                     pressDownTime: 0.1, normalTime: 0.15) { [self] in
                if let controller = storyboard?.instantiateViewController(identifier: "taskRunScreen") {
                    view.endEditing(true)
                    navigationController?.pushViewController(controller, animated: true)
                }
            }
        } else {
            // Adds new cell in Table View + reloads taskList
            Utils.buttonSpringAction(button: addOrSprintButton,
                                     selectedColor: Utils.lavender, normalColor: UIColor.systemIndigo,
                                     pressDownTime: 0.2, normalTime: 0.25) { [self] in
                Utils.tasks.append(Task(name: "", time: "Set time"))
                taskList.reloadData()
                taskList.scrollToRow(at: IndexPath(row: Utils.tasks.count-1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
}


// MARK: - UITableViewDataSource Extension
extension TaskListViewController: UITableViewDataSource {
    
    // Return the number of rows in table view
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return Utils.tasks.count
    }
    
    // Return custom cell + data to show in table view
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        cell.delegate = self
        
        // Gather task data for each taskCell
        let task = Utils.tasks[indexPath.row]
        
        // Configure each taskCell's nameField
        cell.nameField.text = task.name
        cell.nameField.clearButtonMode = .always
        
        // Configure each taskCell's timeButton
        cell.timeButton.setTitle(task.time, for: .normal)
        if timeLeft == 0 {
            // When no time is left
            if cell.timeButton.currentTitle == "Set time" {
                // Disable timeButtons with no set time
                Utils.buttonEnabling(button: cell.timeButton, enable: false)
                cell.timeButton.backgroundColor = UIColor.systemIndigo
            } else {
                // Enable timeButtons with set time
                Utils.buttonEnabling(button: cell.timeButton, enable: true)
                cell.timeButton.backgroundColor = Utils.green
            }
        } else {
            // When there is time left, enable all timeButtons
            Utils.buttonEnabling(button: cell.timeButton, enable: true)
            if cell.timeButton.currentTitle == "Set time" {
                // Color of timeButtons with no set time
                cell.timeButton.backgroundColor = UIColor.systemIndigo
            } else {
                // Color of timeButtons with set time
                cell.timeButton.backgroundColor = Utils.green
            }
        }
        
        // Updates + checks timeLeft label to determine next steps
        updateTimeLeft()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Sets up swipe-to-delete trailing action
        let delete = UIContextualAction(style: .destructive,
                                        title: "Delete") { [unowned self] (action, view, completionHandler) in
            // Update tasks data + current time label
            Utils.tasks.remove(at: indexPath.row)
            
            // Updates + checks timeLeft label to determine next steps
            updateTimeLeft()
            
            // Update tableView
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Update tableView + button positioning
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: Utils.tasks.count-1, section: 0), at: .bottom, animated: true)
            
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
    
    // Called when nameField starts editing
    func nameFieldDidBeginEditing(onCell cell: TaskCell) {
        // Makes selected nameField, the first responder
        cell.nameField.becomeFirstResponder()
    }
    
    // Called when nameField ends editing
    func nameFieldDidEndEditing(onCell cell: TaskCell) {
        // Saves text entered in nameField to tasks data var
        if let indexPath = taskList.indexPath(for: cell) {
            if let newName = cell.nameField.text {
                Utils.tasks[indexPath.row].name = newName
            }
        }
        // Updates + checks timeLeft label to determine next steps
        updateTimeLeft()
        // Ends all editing
        view.endEditing(true)
    }
    
    // Called when nameField returns
    func nameFieldShouldReturn(onCell cell: TaskCell) -> Bool {
        // Ends all editing
        view.endEditing(true)
        return true
    }
    
    // Called when timeButton is pressed
    func pressedTimeButton(onCell cell: TaskCell) {
        // Ends all editing (nameField) if timeButton is pressed
        view.endEditing(true)
        
        // Shows appropriate button click animation + segues to select time
        if cell.timeButton.backgroundColor == Utils.green {
            Utils.buttonSpringAction(button: cell.timeButton,
                                     selectedColor: Utils.teal, normalColor: Utils.green,
                                     pressDownTime: 0.1, normalTime: 0.15) {
                segueToSelectTime()
            }
        } else {
            Utils.buttonSpringAction(button: cell.timeButton,
                                     selectedColor: Utils.lavender, normalColor: UIColor.systemIndigo,
                                     pressDownTime: 0.1, normalTime: 0.15) {
                segueToSelectTime()
            }
        }
        
        // Segue to select time
        func segueToSelectTime() {
            if let indexPath = taskList.indexPath(for: cell) {
                rowIndex = indexPath.row
                performSegue(withIdentifier: "segueToSelectTime", sender: nil)
            }
        }
        
    }

}
