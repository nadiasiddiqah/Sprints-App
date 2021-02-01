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
    @IBOutlet weak var sprintButton: UIButton!
    
    // MARK: - Instance Variables
    var context: NSManagedObjectContext!
    var savedTotalTime: [String] = []
    
    var taskData = [TaskData]()
    
    var taskCount: Int = 1
    var rowIndex = Int()
    
    var taskName = [Int:String]()
    var taskTime = [Int:String]()
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define max height for table view
        taskList.maxHeight = 351
        taskTime[0] = "Set time"
        
        // Connect table view's dataSource and delegate to current view controller
        taskList.delegate = self
        taskList.dataSource = self
        
        // Update time labels on screen
        totalTimeLabel.text = "\(savedTotalTime[0] + ":" + savedTotalTime[1])"
        timeLeftLabel.text = totalTimeLabel.text
    }
    
    // MARK: - Navigation
    
    // Unwind from SelectTimeVC
    @IBAction func unwindFromSelectTime(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! SelectTimeViewController
        taskTime[rowIndex] = controller.selectedTaskTime
        
        taskList.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
    }
    
    // MARK: - Action Methods
    
    // Adds new cell in Table View
    @IBAction func pressedAddTask(_ sender: UIButton) {
        taskCount += 1
        taskTime[taskCount-1] = "Set time"
        taskList.reloadData()
        taskList.scrollToRow(at: IndexPath(row: taskCount-1, section: 0), at: .bottom, animated: true)
    }
    
    // Saves data to Core Data
    @IBAction func pressedSprint(_ sender: Any) {
    }
    
}

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

extension TaskListViewController: UITableViewDelegate {
    
    // De-selects a row after its selected
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TaskListViewController: TaskCellDelegate {
    func nameFieldDidEndEditing(onCell cell: TaskCell) {
        if let indexPath = taskList.indexPath(for: cell) {
            rowIndex = indexPath.row
            print("Task edited on row \(indexPath.row)")
        }
        taskName[rowIndex] = cell.nameField.text
        print(taskName)
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
            print(taskTime)
        }
    }

}

