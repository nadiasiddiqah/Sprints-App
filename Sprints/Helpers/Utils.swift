//
//  Utils.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 2/10/21.
//

import Foundation
import UIKit

class Utils {

    // MARK: - Variables
    static var gradientLayer = CAGradientLayer()

    static var pickedTime = Int()

    static var tasks = [Task]()
    static var taskNames = [String]()
    static var taskTimes = [Int]()

    static var completedTaskInfo = [CompletedTask]()

    static var __maxLengths = [UITextField: Int]()
    
    // MARK: - Colors
    static let blue = #colorLiteral(red: 0.01116534323, green: 0.4508657455, blue: 0.9130660892, alpha: 1)
    static let teal = #colorLiteral(red: 0.08938745409, green: 0.5523278713, blue: 0.5999835134, alpha: 1)
    static let lavender = #colorLiteral(red: 0.4824807048, green: 0.4465178847, blue: 0.9689412713, alpha: 1)
    static let green = #colorLiteral(red: 0, green: 0.6272221804, blue: 0.4726006389, alpha: 1)

    // MARK: - Methods
    static func showTimeLabel(time: Int) -> String {
        let hour = time / 3600
        let min = time / 60 % 60
        return String(format: "%01d:%02d", hour, min)
    }

    static func showSecInLabel(time: Int) -> String {
        var formattedTime = String()
        let hour = time / 60 / 60
        let min = time / 60 % 60
        let sec = time % 60
        
        if hour == 0 {
            formattedTime = String(format: "%02d:%02d", min, sec)
        } else {
            formattedTime = String(format: "%01d:%02d:%02d", hour, min, sec)
        }
        
        return formattedTime
    }

    static func showTimeInSec(time: String) -> Int {
        let components = time.split(separator: ":").map { (x) -> Int in
            return Int(String(x))!
        }
        return (components[0]*60*60) + (components[1]*60)
    }

    static func roundedCorner(object: [UIView]) {
        for i in object {
            i.layer.masksToBounds = true
            i.layer.cornerRadius = 10
        }
    }

    static func buttonEnabling(button: UIButton, enable: Bool) {
        if enable == true {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                button.alpha = 1
            } completion: { _ in
                button.isEnabled = true
            }
        } else {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                button.alpha = 0.6
            } completion: { _ in
                button.isEnabled = false
            }
        }
    }

    static func buttonSpringAction(button: UIButton,
                            selectedColor: UIColor, normalColor: UIColor,
                            pressDownTime: TimeInterval, normalTime: TimeInterval,
                            completionBlock: @escaping () -> Void) {
        UIView.animate(withDuration: pressDownTime, delay: 0,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5,
                       options: .curveEaseIn) {
            button.backgroundColor = selectedColor
            button.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        } completion: { _ in
            UIView.animate(withDuration: normalTime, delay: 0,
                           usingSpringWithDamping: 0.5, initialSpringVelocity: 2,
                           options: .curveEaseIn) {
                button.backgroundColor = normalColor
                button.transform = CGAffineTransform.identity
            } completion: { _ in
                completionBlock()
            }
        }
    }

    static func showGradientLayer(view: UIView) {
        Utils.gradientLayer.colors = [Utils.lavender.cgColor, Utils.blue.cgColor, Utils.teal.cgColor]
        Utils.gradientLayer.frame = view.bounds
        view.layer.insertSublayer(Utils.gradientLayer, at: 0)
    }
}
