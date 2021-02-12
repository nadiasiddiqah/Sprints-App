//
//  TaskRunViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/11/21.
//

import Foundation
import UIKit

class TaskRunViewController: UIViewController {
    
    var sprintTimer: Timer?
    var taskTimer: Timer?
    var totalTime = Int()
    var rowIndex = Int()
    
    var taskTimeInt = Int()

    // MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nextTaskList: UITableView!
    
    @IBOutlet weak var currentTaskView: UIView!
    @IBOutlet weak var taskStatus: UIImageView!
    @IBOutlet weak var currentTaskName: UILabel!
    @IBOutlet weak var currentTaskTime: UILabel!
    @IBOutlet weak var nextTaskButton: UIButton!
    
    // MARK: - Instance Variables
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Connect table view's dataSource and delegate to current view controller
        nextTaskList.delegate = self
        nextTaskList.dataSource = self
        
        // Update timerLabel
        totalTime = pickedTime
        timerLabel.text = showTimeLabel(time: totalTime)
        
        // Sort name and time values
        sortedNameValues = sortTaskInfo(dict: taskName)
        sortedTimeValues = sortTaskInfo(dict: taskTime)
        
        // Add round borders to views
        roundedBorder(object: [currentTaskView, nextTaskList, timerLabel])
        
        startSprintTimer()
        startTaskTimer()
        updateCurrentTaskView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        print("taskCount is:" + "\(taskCount)")
    }
    
    // MARK: - Action methods
    @IBAction func pressedNextTask(_ sender: UIButton) {
        
//        taskStatus.image = UIImage.init(named: "checkmark")
        
        let completedTaskName = sortedNameValues.remove(at: 0)
        let completedTaskTime = sortedTimeValues.remove(at: 0)
        
        if taskTimeInt == 0 || currentTaskTime.text == "No time left" {
            // If current task time runs out
            completedTaskInfo.append([completedTaskName, "0:00", completedTaskTime])
        } else {
            // If current task is finished earlier
            completedTaskInfo.append([completedTaskTime, showTimeLabel(time: taskTimeInt), completedTaskTime])
        }
        reloadTaskViews()
    }
    
    
    // MARK: - Helper methods
//    func startSprintTimer() {
//       Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] (sprintTimer) in
//            timerLabel.text = showTimeLabel(time: pickedTime)
//            if pickedTime > 0 {
//                print("\(pickedTime) left")
//                pickedTime -= 1
//            } else {
//                sprintTimer.invalidate()
//            }
//        })
//    }
    
    func reloadTaskViews() {
        currentTaskName.text = sortedNameValues.first
        currentTaskTime.text = "\(sortedTimeValues.first! + " left")"
        taskCount -= 1
        nextTaskList.reloadData()
    }
    
    
    func startSprintTimer() {
        sprintTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                           selector: #selector(updateSprintTimer),
                                           userInfo: nil, repeats: true)
    }

    @objc func updateSprintTimer() {
        timerLabel.text = showTimeLabel(time: pickedTime)
        if pickedTime > 0 {
            print("\(pickedTime) left")
            pickedTime -= 1
        } else {
            if let sprintTimer = sprintTimer {
                sprintTimer.invalidate()
                timerLabel.text = "Completed"
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
            print("\(taskTimeInt) left")
            taskTimeInt -= 1
        } else {
            if let taskTimer = taskTimer {
                taskTimer.invalidate()
                currentTaskTime.text = "No time left"
            }
        }
    }
    
    func updateCurrentTaskView() {
        currentTaskName.text = sortedNameValues.first
        currentTaskTime.text = "\(sortedTimeValues.first! + " left")"
    }

}


// MARK: - UITableViewDataSource Extension
extension TaskRunViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        if taskCount >= 2 {
            return "Up Next:"
        } else {
            tableView.isHidden = true
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if taskCount >= 2 {
            return taskCount-1
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

