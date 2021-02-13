//
//  TaskRunViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/11/21.
//

import Foundation
import UIKit

class TaskRunViewController: UIViewController {
    
    // MARK: - Instance Variables
    var sprintTimer: Timer?
    var taskTimer: Timer?
    
    var totalTime = Int()
    var taskTimeInt = Int()
    
    var completedAllTasks = false

    // MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nextTaskList: UITableView!
    
    @IBOutlet weak var currentTaskView: UIView!
    @IBOutlet weak var taskStatus: UIImageView!
    @IBOutlet weak var currentTaskName: UILabel!
    @IBOutlet weak var currentTaskTime: UILabel!
    @IBOutlet weak var nextTaskButton: UIButton!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if taskCount > 1 {
            taskCount -= 1
            
            // Connect table view's dataSource and delegate to current view controller
            nextTaskList.delegate = self
            nextTaskList.dataSource = self
        } else {
            nextTaskButton.setTitle("Completed", for: .normal)
            nextTaskButton.backgroundColor = UIColor.systemIndigo
            completedAllTasks = true
            nextTaskList.isHidden = true
        }
    
        print("initial taskCount:" + "\(taskCount)")
        
        // Update timerLabel
        totalTime = pickedTime
        timerLabel.text = showTimeLabel(time: totalTime)
        
        // Sort name and time values
        sortedNameValues = sortTaskInfo(dict: taskName)
        sortedTimeValues = sortTaskInfo(dict: taskTime)
        print(sortedNameValues)
        print(sortedTimeValues)
        
        // Add round borders to views
        roundedBorder(object: [currentTaskView, nextTaskList, timerLabel])
        
        // Start timers
        startSprintTimer()
        startTaskTimer()
        
        // Update current task view
        updateCurrentTaskView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Action methods
    
    //
    @IBAction func pressedNextTask(_ sender: UIButton) {
        
//        taskStatus.image = UIImage.init(named: "checkmark")
        let completedTaskName = sortedNameValues.remove(at: 0)
        let completedTaskTime = sortedTimeValues.remove(at: 0)
        
        if taskTimeInt == 0 || currentTaskTime.text == "No time left" {
            // If current task time runs out
            completedTaskInfo.append([completedTaskName, completedTaskTime, actualTimeSpent(timeSet: completedTaskTime, timeLeft: 0)])
        } else {
            // If current task is finished earlier
            completedTaskInfo.append([completedTaskTime, completedTaskTime, actualTimeSpent(timeSet: completedTaskTime, timeLeft: taskTimeInt)])
        }
        
        if completedAllTasks {
            if let controller = storyboard?.instantiateViewController(identifier: "completedScreen") {
                sprintTimer?.invalidate()
                taskTimer?.invalidate()
                navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            reloadTaskViews()
        }
        print(completedTaskInfo)
    }
    
    
    // MARK: - Helper methods
    func startSprintTimer() {
        sprintTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                           selector: #selector(updateSprintTimer),
                                           userInfo: nil, repeats: true)
    }

    @objc func updateSprintTimer() {
        timerLabel.text = showTimeLabel(time: pickedTime)
        if pickedTime > 0 {
//            print("\(pickedTime) left")
            pickedTime -= 1
        } else {
            if let sprintTimer = sprintTimer {
                sprintTimer.invalidate()
                timerLabel.text = "Time's Up"
            }
        }
    }
    
    func startTaskTimer() {
        taskTimeInt = showTimeInSec(time: sortedTimeValues.first!)
        taskTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                                selector: #selector(updateTaskTimer),
                                                userInfo: taskTimeInt, repeats: true)
    }

    @objc func updateTaskTimer() {
        currentTaskTime.text = "\(showTimeLabel(time: taskTimeInt) + " left")"
        if taskTimeInt > 0 {
//            print("\(taskTimeInt) left")
            taskTimeInt -= 1
        } else {
            if let taskTimer = taskTimer {
                taskTimer.invalidate()
                currentTaskTime.text = "No time left"
            }
        }
    }
    
    func actualTimeSpent(timeSet: String, timeLeft: Int) -> String {
        let timeSetInSec = showTimeInSec(time: timeSet)
        let timeSpent = timeSetInSec - timeLeft
        return showTimeLabel(time: timeSpent)
    }
    
    func updateCurrentTaskView() {
        currentTaskName.text = sortedNameValues.first
        currentTaskTime.text = "\(sortedTimeValues.first! + " left")"
    }
    
    func reloadTaskViews() {
        taskCount -= 1
        print("reloadedView taskCount:" + "\(taskCount)")
        currentTaskName.text = sortedNameValues.first
        currentTaskTime.text = "\(sortedTimeValues.first! + " left")"
        taskTimeInt = showTimeInSec(time: sortedTimeValues.first!)
        updateTaskTimer()
        
        if taskCount > 0 {
            nextTaskList.reloadData()
        } else {
            completedAllTasks = true
            nextTaskButton.setTitle("Complete", for: .normal)
            nextTaskList.isHidden = true
        }
    }
}


// MARK: - UITableViewDataSource Extension
extension TaskRunViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        if taskCount > 0 {
            return "Up Next:"
        } else {
            tableView.isHidden = true
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        print("tableViewRows taskCount:" + "\(taskCount)")
        if taskCount > 0 {
            return taskCount
        } else {
            tableView.isHidden = true
            return 0
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nextTaskCell") as! NextTaskCell
        
        cell.nextTaskName.text = sortedNameValues[indexPath.row+1]
        cell.nextTimeLabel.text = "\(sortedTimeValues[indexPath.row+1] + " left")"
    
        return cell
    }

}

// MARK: - UITableViewDelegate Extension
extension TaskRunViewController: UITableViewDelegate {
}

