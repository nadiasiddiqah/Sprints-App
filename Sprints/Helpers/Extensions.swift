//
//  Extensions.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 6/24/21.
//

import Foundation
import UIKit

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
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

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = Utils.__maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            Utils.__maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
