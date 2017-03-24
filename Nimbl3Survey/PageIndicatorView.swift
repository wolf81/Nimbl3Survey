//
//  PageIndicatorView.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 24/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit
import GLKit

@IBDesignable class PageIndicatorView: UIControl {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        self.count = 5
    }
        
    @IBInspectable var count: UInt = UInt.max {
        didSet {
            self.index = 0
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var index: UInt = UInt.max {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.backgroundColor = .clear
        self.count = 5
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        ctx.saveGState()

        ctx.clear(rect)
        
        let lineWidth: CGFloat = 2
        let margin: CGFloat = 10
        
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setLineWidth(lineWidth)
        
        let x: CGFloat = (rect.origin.x + (rect.width / 2))
        let r: CGFloat = (rect.width / 2) - lineWidth
        var y: CGFloat = (rect.origin.y + r) + (lineWidth / 2)
        
        for i in (0 ..< count) {
            let center = CGPoint(x: x, y: y)
            let endAngle = CGFloat(GLKMathDegreesToRadians(360))
            ctx.addArc(center: center, radius: r, startAngle: 0, endAngle: endAngle, clockwise: true)
            y += ((r * 2) + margin)
            
            if i == self.index {
                ctx.drawPath(using: .fillStroke)
            } else {
                ctx.strokePath()
            }
        }
        
        ctx.restoreGState()
    }
}
