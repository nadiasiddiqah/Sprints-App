//
//  CompletedViewController.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/12/21.
//

import UIKit

class CompletedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//func startTaskTimer() {
//    taskTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
//                                            selector: #selector(updateTaskTimer),
//                                            userInfo: nil, repeats: true)
//}
//
//@objc func updateSprintTimer() {
//    timerLabel.text = showTimeLabel(time: pickedTime)
//    if pickedTime > 0 {
//        print("\(pickedTime) left")
//        pickedTime -= 1
//    } else {
//        if let sprintTimer = sprintTimer {
//            sprintTimer.invalidate()
//        }
//    }
//}

//    @objc func updateTaskTimer() {
//        var taskTimeInt = showTimeInSec(time: sortedTimeValues.first!)
//        currentTaskTime.text = "\(showTimeLabel(time: taskTimeInt) + " left")"
//        if taskTimeInt > 0 {
//            print("\(taskTimeInt) left")
//            taskTimeInt -= 1
//        } else {
//            if let taskTimer = taskTimer {
//                taskTimer.invalidate()
//            }
//        }
//    }


//// MARK: - Global variables
//
//var taskCount: Int = 1
//var pickedTime = Int()
//
//var taskName = [Int:String]()
//var taskTime = [Int:String]()
//
//var sortedNameValues = [String]()
//var sortedTimeValues = [String]()
//
//
//// MARK: - Global helper methods
//
//func showTimeLabel(time: Int) -> String {
//    let hour = time / 60 / 60
//    let min = (time - (hour * 60 * 60)) / 60
//    return String(format: "%01d:%02d", hour, min)
//}
//
//func showTimeInSec(time: String) -> Int {
//    let components = time.split(separator: ":").map { (x) -> Int in
//        return Int(String(x))!
//    }
//    return (components[0]*60*60) + (components[1]*60)
//}
//
//func roundedBorder(object: [UIView]) {
//    for i in object {
//        i.layer.masksToBounds = true
//        i.layer.cornerRadius = 10
//        i.layer.borderWidth = 2
//        i.layer.borderColor = UIColor.black.cgColor
//    }
//}
//
//func sortTaskInfo(dict: [Int:String]) -> [String] {
//    let sortByKey = dict.keys.sorted()
//    var sortedValues = [String]()
//    for key in sortByKey {
//        let sortByValue = dict[key]
//        sortedValues.append(sortByValue!)
//    }
//    return sortedValues
//}
