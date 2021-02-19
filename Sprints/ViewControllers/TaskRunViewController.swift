//
//  TaskRunViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/11/21.
//

import Foundation
import UIKit
import Lottie
import Gifu

class TaskRunViewController: UIViewController {
    
    // MARK: - Instance Variables
    var sprintTimer: Timer?
    var taskTimer: Timer?
    
    var totalTime = Int()
    var taskTimeInt = Int()
    
    var completedAllTasks = false
    
    lazy var animatedCheckmark: GIFImageView = {
        let view = GIFImageView(frame: CGRect(x: checkmarkBox.frame.origin.x, y: checkmarkBox.frame.origin.y, width: checkmarkBox.frame.width, height: checkmarkBox.frame.height))
        view.contentMode = .scaleAspectFit
        view.animate(withGIFNamed: "animatedCheckmark")
        view.animationRepeatCount = 1
        return view
    }()

    // MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nextTaskList: UITableView!
    @IBOutlet weak var checkmarkBox: UIImageView! {
        didSet {
            checkmarkBox.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var currentTaskView: UIView!
    @IBOutlet weak var currentTaskName: UILabel!
    @IBOutlet weak var currentTaskTime: UILabel!
    @IBOutlet weak var nextTaskButton: UIButton!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up task views based on # of tasks
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
    
//        print("initial taskCount:" + "\(taskCount)")
        
        // Update timerLabel
        totalTime = pickedTime
        timerLabel.text = showTimeLabel(time: totalTime)
        
        // Sort name and time values
//        sortedNameValues = sortTaskInfo(dict: taskName)
//        sortedTimeValues = sortTaskInfo(dict: taskTime)
        
        // Add round borders to views
        roundedBorder(object: [currentTaskView, nextTaskList, timerLabel])
        
        // Start timers
        startSprintTimer()
        startTaskTimer()
        
        // Update current task view
        updateCurrentTaskView()
        
        // Tap gesture recognizer
        tapToShowCheckmark()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Action methods
    
    @IBAction func pressedNextTask(_ sender: UIButton) {
        determineNextStep()
    }
    
    
    // MARK: - Helper methods
    func determineNextStep() {
        // Show animated checkmark
        checkmarkBox.addSubview(animatedCheckmark)
        // Disable nextTaskButton + checkmarkBox
        nextTaskButton.isEnabled = false
        checkmarkBox.isUserInteractionEnabled = false
        
        // Delay striking through text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [self] in
            currentTaskName.strikeThroughText()
            currentTaskTime.strikeThroughText()
        }
        
        // Delay updating completed task info + checking for completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            saveCompletedTaskInfo()
            checkForCompletion()
            // Reenable nextTaskButton + checkmarkBox
            nextTaskButton.isEnabled = true
            checkmarkBox.isUserInteractionEnabled = true
        }
    }
    
    // Save completed task info
    func saveCompletedTaskInfo() {
        // Remove completedTaskName/Time from array with fade
        currentTaskName.fadeTransition(0.6)
        currentTaskTime.fadeTransition(0.6)
        let completedTaskName = sortedNameValues.remove(at: 0)
        let completedTaskTime = sortedTimeValues.remove(at: 0)
        
        // Check taskTimeInt (of current task) to update completedTaskInfo
        if taskTimeInt == 0 || currentTaskTime.text == "No time left" {
            // If current task time runs out
            completedTaskInfo.append([completedTaskName, completedTaskTime, actualTimeSpent(timeSet: completedTaskTime, timeLeft: 0)])
        } else {
            // If current task is finished earlier
            completedTaskInfo.append([completedTaskName, completedTaskTime, actualTimeSpent(timeSet: completedTaskTime, timeLeft: taskTimeInt)])
        }
    }
    
    // Check if all tasks are completed to update screen
    func checkForCompletion() {
        if completedAllTasks {
            // If all tasks completed, segue to completed screen
            if let controller = storyboard?.instantiateViewController(identifier: "completedScreen") {
                sprintTimer?.invalidate()
                taskTimer?.invalidate()
                navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            // If more tasks left, update task view info
            reloadTaskViews()
        }
        print(completedTaskInfo)
    }
    
    // Shows checkmark
    func tapToShowCheckmark() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCheckmark(_:)))
        checkmarkBox.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func showCheckmark(_ sender: UITapGestureRecognizer) {
        determineNextStep()
    }
    
    func showSquare() {
        animatedCheckmark.removeFromSuperview()
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
            print("\(taskTimeInt) left")
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
        
        showSquare()
        
        currentTaskName.removeStrikeThrough()
        currentTaskTime.removeStrikeThrough()
        
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

