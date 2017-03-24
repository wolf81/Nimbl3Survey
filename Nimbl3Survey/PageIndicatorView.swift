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
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear        
    }
    
    @IBInspectable var count: Int = NSNotFound {
        didSet {
            self.index = 0
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var index: Int = NSNotFound {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var indicatorColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 2 {
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
        guard self.count != NSNotFound else {
            return
        }
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        ctx.saveGState()

        ctx.clear(rect)
        
        let lineWidth: CGFloat = 2
        let margin: CGFloat = 10
        
        ctx.setFillColor(self.indicatorColor.cgColor)
        ctx.setStrokeColor(self.indicatorColor.cgColor)
        ctx.setLineWidth(self.lineWidth)
        
        let x: CGFloat = (rect.origin.x + (rect.width / 2))
        let r: CGFloat = (rect.width / 2) - lineWidth
        let h = (rect.width - lineWidth)
        
        let totalHeight = CGFloat(self.count) * h + fmax(CGFloat((self.count - 1)), CGFloat(0)) * margin
        var y: CGFloat = (rect.origin.y + rect.size.height / 2) - (totalHeight / 2) + h / 2

        for i in (0 ..< count) {
            let origin = CGPoint(x: x, y: y)
            let fill = (i == self.index)
            
            drawCircleAtOrigin(origin, radius: r, fill: fill, inContext: ctx)

            y += (h + margin)
        }
        
        ctx.restoreGState()
    }
    
    // MARK: - Private
    
    private func drawCircleAtOrigin(_ origin: CGPoint, radius: CGFloat, fill: Bool, inContext ctx: CGContext) {
        let endAngle = CGFloat(GLKMathDegreesToRadians(360))
        ctx.addArc(center: origin, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)

        if fill {
            ctx.drawPath(using: .fillStroke)
        } else {
            ctx.strokePath()
        }
    }
}
