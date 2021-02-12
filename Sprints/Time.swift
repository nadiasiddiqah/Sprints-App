//
//  Time.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 2/10/21.
//

import Foundation
import UIKit

// MARK: - Global variables

var taskCount: Int = 1
var pickedTime = Int()
var taskName = [Int:String]()
var taskTime = [Int:String]()

var sortedNameValues = [String]()
var sortedTimeValues = [String]()


// MARK: - Global helper methods

func showTimeLabel(time: Int) -> String {
    let hour = time / 60 / 60
    let min = (time - (hour * 60 * 60)) / 60
    return String(format: "%01d:%02d", hour, min)
}

func showTimeInSec(time: String) -> Int {
    let components = time.split(separator: ":").map { (x) -> Int in
        return Int(String(x))!
    }
    return (components[0]*60*60) + (components[1]*60)
}

func roundedBorder(object: [UIView]) {
    for i in object {
        i.layer.masksToBounds = true
        i.layer.cornerRadius = 10
        i.layer.borderWidth = 2
        i.layer.borderColor = UIColor.black.cgColor
    }
}

func sortTaskInfo(dict: [Int:String]) -> [String] {
    let sortByKey = dict.keys.sorted()
    var sortedValues = [String]()
    for key in sortByKey {
        let sortByValue = dict[key]
        sortedValues.append(sortByValue!)
    }
    return sortedValues
}


