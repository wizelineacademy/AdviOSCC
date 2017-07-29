//
//  Shakable.swift
//  POP-Views
//
//  Created by Thien Liu on 7/28/17.
//  Copyright © 2017 Thien Liu. All rights reserved.
//

import UIKit

protocol Shakable {
    func shake()
}

extension Shakable where Self: UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5.0, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
}

