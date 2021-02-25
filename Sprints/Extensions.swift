//
//  Extensions.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 2/18/21.
//

import Foundation
import UIKit

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension UILabel {
  func strikeThroughText() {
    let attributeString = NSMutableAttributedString(string: self.text ?? "")
    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                 value: NSUnderlineStyle.single.rawValue,
                                 range: NSMakeRange(0,attributeString.length))
    attributeString.addAttribute(NSAttributedString.Key.strikethroughColor,
                                 value: UIColor.black,
                                 range: NSMakeRange(0, attributeString.length))
    self.attributedText = attributeString
  }
  
    func removeStrikeThrough() {
        let attributeString = NSMutableAttributedString(string: self.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0,attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor,
                                     value: UIColor.clear,
                                     range: NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
    }
    
}
