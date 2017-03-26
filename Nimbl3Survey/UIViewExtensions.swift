//
//  UIViewExtensions.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 26/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

extension UIView {
    func startRotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = NSNumber(value: M_PI * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = FLT_MAX
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotate() {
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    func startRotation(_ duration: CFTimeInterval = 1, repeatCount: Float = Float.infinity, clockwise: Bool = true) {
        if self.layer.animation(forKey: "transform.rotation.z") != nil {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        let direction = clockwise ? 1.0 : -1.0
        animation.toValue = NSNumber(value: M_PI * 2 * direction)
        animation.duration = duration
        animation.isCumulative = true
        animation.repeatCount = repeatCount
        
        self.layer.add(animation, forKey:"transform.rotation.z")
    }
    
    func stopRotation() {
        self.layer.removeAnimation(forKey: "transform.rotation.z")
    }
}
