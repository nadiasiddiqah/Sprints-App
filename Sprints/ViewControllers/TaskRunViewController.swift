//
//  TaskRunViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/11/21.
//

import Foundation
import UIKit
import Gifu

// MARK: CompeletedTask struct
struct CompletedTask {
    var name: String
    var setTime: Int
    var actualTime: Int
}

class TaskRunViewController: UIViewController {
    
    // MARK: - Instance Variables
    var sprintTimer: Timer?
    var taskTimer: Timer?
    
    var taskTimeCounter = Int()
    var taskCounter = Int()
    
    var completedAllTasks = false
    
    lazy var animatedCheckmark: GIFImageView = {
        let view = GIFImageView(frame: CGRect(x: checkmarkBox.frame.origin.x, y: checkmarkBox.frame.origin.y, width: checkmarkBox.frame.width, height: checkmarkBox.frame.height))
        view.contentMode = .scaleAspectFit
        view.animate(withGIFNamed: "animatedCheckmark")
        view.animationRepeatCount = 1
        return view
    }()

    // MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel! {
        didSet {
            timerLabel.text = showSecInLabel(time: pickedTime)
        }
    }
    
    @IBOutlet weak var nextTaskList: UITableView!
    
    @IBOutlet weak var checkmarkBox: UIImageView! {
        didSet {
            checkmarkBox.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var currentTaskView: UIView!
    
    @IBOutlet weak var currentTaskName: UILabel! {
        didSet {
            currentTaskName.adjustsFontSizeToFitWidth = true
        }
    }

    @IBOutlet weak var currentTaskTime: UILabel!
    @IBOutlet weak var nextTaskButton: UIButton!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up task views based on # of tasks
        if tasks.count > 1 {
            // If there is more than 2 tasks
            // taskCounter = # of tasks to show in nextTaskList
            taskCounter = tasks.count - 1
            
            // Connect table view's dataSource and delegate to current view controller
            nextTaskList.delegate = self
            nextTaskList.dataSource = self
        } else {
            // If there is 1 or less tasks
            nextTaskButton.setTitle("Completed", for: .normal)
            nextTaskButton.backgroundColor = UIColor.systemIndigo
            completedAllTasks = true
            nextTaskList.isHidden = true
        }
        
        // Compile taskName and taskTime values
        for task in tasks {
            taskNames.append(task.name)
            taskTimes.append(showTimeInSec(time: task.time))
        }
        
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
    
    // Hide navigation bar before view loads
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Action methods
    
    // If nextTaskButton is pressed
    @IBAction func pressedNextTask(_ sender: UIButton) {
        determineNextStep()
    }
    
    // MARK: - Timer Methods
    func startSprintTimer() {
        sprintTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                           selector: #selector(updateSprintTimer),
                                           userInfo: nil, repeats: true)
    }

    @objc func updateSprintTimer() {
        if pickedTime > 0 {
            print("\(pickedTime) left")
            pickedTime -= 1
            timerLabel.text = showSecInLabel(time: pickedTime)
        } else {
            if let sprintTimer = sprintTimer {
                sprintTimer.invalidate()
                timerLabel.text = "0:00"
                performSegue(withIdentifier: "completedScreen", sender: nil)
            }
        }
    }
    
    func startTaskTimer() {
        taskTimeCounter = taskTimes.first!
        taskTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                                selector: #selector(updateTaskTimer),
                                                userInfo: taskTimeCounter, repeats: true)
    }

    @objc func updateTaskTimer() {
        if taskTimeCounter > 0 {
            print("\(taskTimeCounter) left")
            taskTimeCounter -= 1
            currentTaskTime.text = "\(showSecInLabel(time: taskTimeCounter) + " left")"
        } else {
            if let taskTimer = taskTimer {
                taskTimer.invalidate()
                currentTaskTime.text = "No time left"
                determineNextStep()
            }
        }
    }
    
    // Determine next step after checkmarkBox or nextTaskButton is pressed
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
        // Use fade transition to remove taskNames/taskTimes from array
        currentTaskName.fadeTransition(0.6)
        currentTaskTime.fadeTransition(0.6)
        let removeName = taskNames.remove(at: 0)
        let removeTime = taskTimes.remove(at: 0)
        
        // Check taskTimeCounter (of current task) to update completedTaskInfo
        if taskTimeCounter == 0 || currentTaskTime.text == "No time left" {
            // If current task time runs out
            completedTaskInfo.append(CompletedTask(name: removeName, setTime: removeTime,
                                                   actualTime: removeTime))
        } else {
            // If current task is finished earlier
            completedTaskInfo.append(CompletedTask(name: removeName, setTime: removeTime,
                                                   actualTime: removeTime-taskTimeCounter))
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
    
    // MARK: - Checkmark Methods
    
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
    
    // MARK: - TaskView Methods
    func updateCurrentTaskView() {
        currentTaskName.text = taskNames.first
        currentTaskTime.text = "\(showTimeLabel(time: taskTimes.first!) + " left")"
    }
    
    func reloadTaskViews() {
        taskCounter -= 1
        
        showSquare()
        
        currentTaskName.removeStrikeThrough()
        currentTaskTime.removeStrikeThrough()
        
        updateCurrentTaskView()
        
        taskTimeCounter = taskTimes.first!
        updateTaskTimer()
        
        if taskCounter > 0 {
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
        if taskCounter > 0 {
            return "Up Next:"
        } else {
            tableView.isHidden = true
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if taskCounter > 0 {
            return taskCounter
        } else {
            tableView.isHidden = true
            return 0
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nextTaskCell") as! NextTaskCell
        
        cell.nextTaskName.text = taskNames[indexPath.row+1]
        cell.nextTaskName.adjustsFontSizeToFitWidth = true
        cell.nextTimeLabel.text = "\(showTimeLabel(time: taskTimes[indexPath.row+1]) +  " left")"
    
        return cell
    }

}

// MARK: - UITableViewDelegate Extension
extension TaskRunViewController: UITableViewDelegate {
}

