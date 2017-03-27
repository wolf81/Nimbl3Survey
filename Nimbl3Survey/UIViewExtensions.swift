//
//  UIViewExtensions.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 26/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

extension UIView {
    private static let zRotateAnimationKey = "transform.rotation.z"
    
    func startRotation(_ duration: CFTimeInterval = 1, repeatCount: Float = Float.infinity, clockwise: Bool = true) {
        if self.layer.animation(forKey: UIView.zRotateAnimationKey) != nil {
            return
        }
        
        let animation = CABasicAnimation(keyPath: UIView.zRotateAnimationKey)
        let direction = clockwise ? 1.0 : -1.0
        animation.toValue = NSNumber(value: M_PI * 2 * direction)
        animation.duration = duration
        animation.isCumulative = true
        animation.repeatCount = repeatCount
        
        self.layer.add(animation, forKey:UIView.zRotateAnimationKey)
    }
    
    func stopRotation() {
        self.layer.removeAnimation(forKey: UIView.zRotateAnimationKey)
    }
}
