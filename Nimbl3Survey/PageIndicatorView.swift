//
//  PageIndicatorView.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 24/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit
import GLKit

protocol PageIndicatorViewDelegate: class {
    func pageIndicatorView(_ view: PageIndicatorView, touchedIndicatorAtIndex index: Int)
}

class PageIndicatorView: UIControl {
    private let horizontalMargin: CGFloat = 2
    
    weak var delegate: PageIndicatorViewDelegate?
    
    private var indicatorTouchRects = [CGRect]()
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        self.layer.masksToBounds = true
    }
    
    // MARK: - Properties
    
    override var frame: CGRect {
        didSet {
            self.layer.cornerRadius = fmin(bounds.width / 2, 10)
        }
    }
    
    var count: Int = NSNotFound {
        didSet {
            self.index = 0
            setNeedsDisplay()
        }
    }
    
    var index: Int = NSNotFound {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var indicatorColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Drawing

    override func draw(_ rect: CGRect) {
        guard self.count != NSNotFound else {
            return
        }
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        ctx.saveGState()

        ctx.clear(rect)

        let highlighted = (self.isSelected || self.isHighlighted)
        
        if highlighted {
            let backgroundColor = UIColor(white: 0, alpha: 0.5)
            ctx.setFillColor(backgroundColor.cgColor)
            ctx.fill(rect)
        }
        
        let lineWidth: CGFloat = 2
        let verticalMargin: CGFloat = 10
        
        let foregroundColor = highlighted ? self.indicatorColor.withAlphaComponent(0.5) : self.indicatorColor
        
        ctx.setFillColor(foregroundColor.cgColor)
        ctx.setStrokeColor(foregroundColor.cgColor)
        ctx.setLineWidth(self.lineWidth)
        
        let x: CGFloat = (rect.origin.x + (rect.width / 2))
        let r: CGFloat = (rect.width / 2) - lineWidth - self.horizontalMargin
        let h = (rect.width - lineWidth - (self.horizontalMargin * 2))
        
        let totalHeight = CGFloat(self.count) * h + fmax(CGFloat((self.count - 1)), CGFloat(0)) * verticalMargin
        var y: CGFloat = (rect.origin.y + rect.size.height / 2) - (totalHeight / 2) + h / 2

        for i in (0 ..< count) {
            let origin = CGPoint(x: x, y: y)
            let fill = (i == self.index)
            
            drawCircleInContext(ctx, atOrigin: origin, withRadius: r, fill: fill)

            let touchRect = touchRectForCircleAtOrigin(origin, withRadius: r, inRect: rect)
            self.indicatorTouchRects.append(touchRect)
            
            y += (h + verticalMargin)
        }
        
        ctx.restoreGState()
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width = min(16 + (self.horizontalMargin * 2), size.width)
        return CGSize(width: width, height: size.height)
    }
    
    // MARK: - State changes
    
    override var isSelected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - User interaction
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        // TODO: When user touch, immediately navigate to the nearest page
        //  Perhaps create a list of rects for circles and send touched index
        //  back through a delegate.
        
        guard let touch = touches.first else {
            return
        }
        
        let point = touch.location(in: self)
        
        guard let touchedRect = (self.indicatorTouchRects.filter { rect in
            return rect.contains(point)
        }).first else { return }
        
        if let index = self.indicatorTouchRects.index(of: touchedRect) {
            self.delegate?.pageIndicatorView(self, touchedIndicatorAtIndex: index)
        }
    }

    // MARK: - Private
    
    private func touchRectForCircleAtOrigin(_ origin: CGPoint, withRadius radius: CGFloat, inRect rect: CGRect) -> CGRect {
        var touchRect = CGRect()
        touchRect.origin.y = origin.y - radius
        touchRect.origin.x = 0
        touchRect.size.height = radius * 2
        touchRect.size.width = rect.width
        return touchRect
    }
    
    private func drawCircleInContext(_ ctx: CGContext, atOrigin origin: CGPoint, withRadius radius: CGFloat, fill: Bool) {
        let endAngle = CGFloat(GLKMathDegreesToRadians(360))
        ctx.addArc(center: origin, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)

        if fill {
            ctx.drawPath(using: .fillStroke)
        } else {
            ctx.strokePath()
        }
    }
}
