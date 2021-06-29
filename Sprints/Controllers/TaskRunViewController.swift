//
//  TaskRunViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/11/21.
//

import Foundation
import UIKit
import Gifu

class TaskRunViewController: UIViewController {
    
    // MARK: - Instance Variables
    var sprintTimer: Timer?
    var taskTimer: Timer?
    
    var taskTimeCounter = Int()
    var taskCounter = Int()
    var addedTime = 0
    var subtractedTime = 0
    var aheadByTime = 0
    
    var completedAllTasks = false
    var pressedPlay = false
    var disableSubtractButton = false
    
    // MARK: - Lazy Variables
    lazy var animatedCheckmark: GIFImageView = {
        let gif = GIFImageView(frame: CGRect(x: checkmarkBox.frame.origin.x, y: checkmarkBox.frame.origin.y,
                                             width: checkmarkBox.frame.width, height: checkmarkBox.frame.height))
        gif.contentMode = .scaleAspectFit
        gif.animate(withGIFNamed: "animatedCheckmark")
        gif.animationRepeatCount = 1
        return gif
    }()

    // MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel! {
        didSet {
            timerLabel.text = Utils.showSecInLabel(time: Utils.pickedTime)
        }
    }
    @IBOutlet weak var pauseOrPlayButton: UIButton!
    @IBOutlet weak var addMinuteButton: UIButton!
    @IBOutlet weak var subtractMinuteButton: UIButton!
    @IBOutlet weak var timeTrackerLabel: UILabel!
    
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
    
    @IBOutlet weak var nextTaskList: UITableView!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up task views based on # of tasks
        if Utils.tasks.count > 1 {
            // If there is more than 2 tasks
            // taskCounter = # of tasks to show in nextTaskList
            taskCounter = Utils.tasks.count - 1
            
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
        for task in Utils.tasks {
            Utils.taskNames.append(task.name)
            Utils.taskTimes.append(Utils.showTimeInSec(time: task.time))
        }
        
        // Add round borders to views
        Utils.roundedBorder(object: [currentTaskView, nextTaskList, timerLabel])
        
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
        Utils.showGradientLayer(view: view)
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
        if Utils.pickedTime > 0 {
            Utils.pickedTime -= 1
            timerLabel.text = Utils.showSecInLabel(time: Utils.pickedTime)
        } else {
            if let sprintTimer = sprintTimer {
                sprintTimer.invalidate()
                timerLabel.text = "0:00"
                performSegue(withIdentifier: "completedScreen", sender: nil)
            }
        }
    }
    
    func startTaskTimer() {
        if pressedPlay {
            taskTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                                    selector: #selector(updateTaskTimer),
                                                    userInfo: taskTimeCounter, repeats: true)
        } else {
            taskTimeCounter = Utils.taskTimes.first!
            taskTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                                    selector: #selector(updateTaskTimer),
                                                    userInfo: taskTimeCounter, repeats: true)
        }
    }

    @objc func updateTaskTimer() {
        if taskTimeCounter > 0 {
            taskTimeCounter -= 1
            enableOrDisableSubtractMinuteButton()
            currentTaskTime.text = "\(Utils.showSecInLabel(time: taskTimeCounter) + " left")"
        } else {
            if let taskTimer = taskTimer {
                taskTimer.invalidate()
                currentTaskTime.text = "No time left"
                determineNextStep()
            }
        }
    }
    
    @IBAction func pressedPauseOrPlay(_ sender: UIButton) {
        if pauseOrPlayButton.currentImage == UIImage(systemName: "pause.circle.fill") {
            showPlayButton()
        } else {
            showPauseButton()
        }
    }
    
    func showPlayButton() {
        pressedPlay = true
        pauseOrPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        
        sprintTimer?.invalidate()
        taskTimer?.invalidate()
        
        Utils.buttonEnabling(button: addMinuteButton, enable: false)
        Utils.buttonEnabling(button: subtractMinuteButton, enable: false)
        Utils.buttonEnabling(button: nextTaskButton, enable: false)
        checkmarkBox.isUserInteractionEnabled = false
    }
    
    func showPauseButton() {
        pauseOrPlayButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        
        startSprintTimer()
        startTaskTimer()
        
        Utils.buttonEnabling(button: subtractMinuteButton, enable: disableSubtractButton)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) { [self] in
            Utils.buttonEnabling(button: addMinuteButton, enable: true)
            Utils.buttonEnabling(button: nextTaskButton, enable: true)
            checkmarkBox.isUserInteractionEnabled = true
            pressedPlay = false
        }
    }
    
    @IBAction func addMinute(_ sender: UIButton) {
        addedTime += 60
        Utils.pickedTime += 60
        taskTimeCounter += 60
        print("pressed add minute")
    }
    
    @IBAction func subtractMinute(_ sender: UIButton) {
        if taskTimeCounter > 60 {
            disableSubtractButton = false
            Utils.buttonEnabling(button: subtractMinuteButton, enable: true)
            subtractedTime -= 60
            Utils.pickedTime -= 60
            taskTimeCounter -= 60
        } else {
            disableSubtractButton = true
            Utils.buttonEnabling(button: subtractMinuteButton, enable: false)
        }
        print("pressed subtract minute")
    }
    
    func enableOrDisableSubtractMinuteButton() {
        if taskTimeCounter > 60 {
            disableSubtractButton = false
            Utils.buttonEnabling(button: subtractMinuteButton, enable: true)
        } else {
            disableSubtractButton = true
            Utils.buttonEnabling(button: subtractMinuteButton, enable: false)
        }
    }
    
    // MARK: - Next Step Methods
    // Determine next step after checkmarkBox or nextTaskButton is pressed
    func determineNextStep() {
        // Show animated checkmark
        checkmarkBox.addSubview(animatedCheckmark)
        
        // Disable nextTaskButton + checkmarkBox
        nextTaskButton.isEnabled = false
        checkmarkBox.isUserInteractionEnabled = false
        
        sprintTimer?.invalidate()
        taskTimer?.invalidate()
        
        // Delay striking through text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [self] in
            currentTaskName.strikeThroughText()
            currentTaskTime.strikeThroughText()
        }
        
        // Delay updating completed task info + checking for completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
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
        let removeName = Utils.taskNames.remove(at: 0)
        let removeTime = Utils.taskTimes.remove(at: 0)
        let timeControl = addedTime + subtractedTime
        
        // Check taskTimeCounter (of current task) to update completedTaskInfo
        if taskTimeCounter == 0 || currentTaskTime.text == "No time left" {
            if timeControl == 0 {
                // If current task time runs out + no time added/subtracted
                Utils.completedTaskInfo.append(CompletedTask(name: removeName, setTime: removeTime,
                                                             actualTime: removeTime))
                print("current task time runs out + no time added/subtracted")
            } else {
                // If current task time runs out + time is added/subtracted
                Utils.completedTaskInfo.append(CompletedTask(name: removeName, setTime: removeTime,
                                                             actualTime: removeTime+timeControl))
                print("timeControl: \(timeControl)")
                print("current task time runs out + time is added/subtracted")
                
                if timeControl < 0 {
                    timeTrackerLabel.isHidden = false
                    aheadByTime -= timeControl
                    timeTrackerLabel.text = "You're ahead by \(Utils.showSecInLabel(time: aheadByTime))!"
                } else if aheadByTime <= 0 {
                    timeTrackerLabel.isHidden = true
                    aheadByTime -= timeControl
                }
            }
        } else {
            // If current task is finished earlier
            Utils.completedTaskInfo.append(CompletedTask(name: removeName, setTime: removeTime,
                                                         actualTime: removeTime-taskTimeCounter+timeControl))
            print("timeControl: \(timeControl)")
            print("current task is finished earlier")
            
            aheadByTime += taskTimeCounter
            if aheadByTime > 0 {
                timeTrackerLabel.isHidden = false
                timeTrackerLabel.text = "You're ahead by \(Utils.showSecInLabel(time: aheadByTime))!"
            } else if aheadByTime <= 0 {
                timeTrackerLabel.isHidden = true
                aheadByTime -= timeControl
            }
        }
    }
    
    // Check if all tasks are completed to update screen
    func checkForCompletion() {
        if completedAllTasks {
            // If all tasks completed, segue to completed screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                if let controller = storyboard?.instantiateViewController(identifier: "completedScreen") {
                    navigationController?.pushViewController(controller, animated: true)
                }
            }
        } else {
            // If more tasks left, update task view info
            reloadTaskViews()
        }
        print(Utils.completedTaskInfo)
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
        currentTaskName.text = Utils.taskNames.first
        currentTaskTime.text = "\(Utils.showSecInLabel(time: Utils.taskTimes.first!) + " left")"
    }
    
    func reloadTaskViews() {
        taskCounter -= 1
        addedTime = 0
        subtractedTime = 0
        
        showSquare()
        
        currentTaskName.removeStrikeThrough()
        currentTaskTime.removeStrikeThrough()
        
        updateCurrentTaskView()
        
        startTaskTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
            self.startSprintTimer()
        }
        
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
        
        cell.nextTaskName.text = Utils.taskNames[indexPath.row+1]
        cell.nextTaskName.adjustsFontSizeToFitWidth = true
        cell.nextTimeLabel.text = "\(Utils.showSecInLabel(time: Utils.taskTimes[indexPath.row+1]) +  " left")"
    
        return cell
    }

}

// MARK: - UITableViewDelegate Extension
extension TaskRunViewController: UITableViewDelegate {
    // De-selects a row after its selected
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

