//
//  Time.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 2/10/21.
//

import Foundation

// Global variables
var pickedTime = Int()
var taskName = [Int:String]()
var taskTime = [Int:String]()

// Global helper methods
func showTimeLabel(time: Int) -> String {
    let hour = time / 60 / 60
    let min = (time - (hour * 60 * 60)) / 60
    return String(format: "%01d:%02d", hour, min)
}

