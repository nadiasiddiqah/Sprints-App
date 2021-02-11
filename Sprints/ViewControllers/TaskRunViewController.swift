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
    var totalTime = Int()
    var rowIndex = Int()

    // MARK: - Outlets
    @IBOutlet weak var taskRunList: UITableView!
    @IBOutlet weak var nextTaskList: UITableView!
    @IBOutlet weak var timerLabel: UILabel!
    
    // MARK: - Instance Variables
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Connect table view's dataSource and delegate to current view controller
        taskRunList.delegate = self
        taskRunList.dataSource = self
        nextTaskList.delegate = self
        nextTaskList.dataSource = self
        
        // Update timerLabel
        totalTime = pickedTime
        timerLabel.text = showTimeLabel(time: totalTime)
        
        startSprintTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
            print("\(pickedTime) left")
            pickedTime -= 1
        } else {
            if let sprintTimer = sprintTimer {
                sprintTimer.invalidate()
            }
        }
    }

}


// MARK: - UITableViewDataSource Extension
extension TaskRunViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        if tableView == taskRunList {
            return "Current task:"
        } else {
            return "Up Next:"
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if tableView == taskRunList {
            return 1
        } else {
            return taskCount-1
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if let taskRunCell = tableView.dequeueReusableCell(withIdentifier: "taskRunCell") as? TaskRunCell {
            cell = taskRunCell
            (cell as! TaskRunCell).delegate = self
            taskRunCell.taskName.text = taskName[0]
            taskRunCell.timeLabel.text = "\(taskTime[0]! + " left")"
        } else {
            let nextTaskCell = tableView.dequeueReusableCell(withIdentifier: "nextTaskCell") as! NextTaskCell
            cell = nextTaskCell
            nextTaskCell.nextTaskName.text = taskName[indexPath.row+1]
            nextTaskCell.nextTimeLabel.text = "\(taskTime[indexPath.row+1]! + " left")"
        }
        
        return cell
        
        //        if tableView == taskRunList {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "taskRunCell") as! TaskRunCell
        //            cell.taskName.text = taskName[0]
        //            cell.timeLabel.text = "\(taskTime[0]! + " left")"
        //        } else {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "nextTaskCell") as! NextTaskCell
        //            cell.nextTaskName.text = taskName[indexPath.row+1]
        //            cell.nextTimeLabel.text = "\(taskTime[indexPath.row+1]! + " left")"
        //        }
        
        //        var cell: UITableViewCell
        //
        //        if let taskRunCell = tableView.dequeueReusableCell(withIdentifier: "taskRunCell") as? TaskRunCell {
        //            cell = taskRunCell
        //            taskRunCell.taskName.text = taskName[0]
        //            taskRunCell.timeLabel.text = "\(taskTime[0]! + " left")"
        //        } else {
        //            if taskCount >= 2 {
        //                let nextTaskCell = tableView.dequeueReusableCell(withIdentifier: "nextTaskCell") as! NextTaskCell
        //                cell = nextTaskCell
        //                nextTaskCell.nextTaskName.text = taskName[indexPath.row+1]
        //                nextTaskCell.nextTimeLabel.text = "\(taskTime[indexPath.row+1]! + " left")"
        //            } else {
        //                nextTaskList.isHidden = true
        //            }
        //        }
        //        return cell
    }

}


// MARK: - UITableViewDelegate Extension
extension TaskRunViewController: UITableViewDelegate {

}

extension TaskRunViewController: TaskRunCellDelegate {
    func pressedNextTaskButton(onCell cell: TaskRunCell) {
        if let indexPath = taskRunList.indexPath(for: cell) {
            rowIndex = indexPath.row
            completedTaskName[rowIndex] = taskName[rowIndex]
            completedTaskTime[rowIndex] = taskTime[rowIndex]
            
            print("completedTaskName: \(completedTaskName)")
            print("completedTaskTime: \(completedTaskTime)")
        }
        taskName[rowIndex] = nil
        taskTime[rowIndex] = nil
    }
}
