//
//  CCLoadingView.swift
//  CCLoading
//
//  Created by Chun Ye (chunforios@gmail.com)on 12/10/14.
//  Github: https://github.com/yechunjun/CCActivityIndicatorView
//  Blog: http://chun.tips
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

import UIKit
import Foundation

struct Config {
    static let CC_ACTIVITY_INDICATOR_VIEW_WIDTH = 40
    static let CC_ARC_DRAW_PADDING = 3.0
    static let CC_ARC_DRAW_DEGREE = 39.0
    static let CC_ARC_DRAW_WIDTH = 6.0
    static let CC_ARC_DRAW_RADIUS = 10.0
    static let CC_ARC_DRAW_COLORS = [UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor, UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).CGColor, UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor]
}

// MARK: Math Helpers

func DegreesToRadians (value: Double) -> Double {
    return value * M_PI / 180.0
}

// MARK: Activity Indicator View

@IBDesignable class CCActivityIndicatorView: UIView {
    
    /// default is true. calls -setHidden when animating gets set to NO
    @IBInspectable var hidesWhenStopped : Bool = true
    
    func startAnimating () {
        
        if self.hidden {
            self.hidden = false
        }
        
        if let timer = self.animatedTimer {
            timer.fire()
        } else {
            self.animatedTimer = NSTimer(timeInterval: 0.1, target: self, selector: "animate", userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(self.animatedTimer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    func stopAnimating () {
        if let timer = self.animatedTimer {
            timer.invalidate()
            self.animatedTimer = nil
            if self.hidesWhenStopped {
                if !self.hidden {
                    self.hidden = true
                }
            }
        }
    }
    
    func isAnimating () -> Bool {
        if let timer = self.animatedTimer {
            return timer.valid
        } else {
            return false
        }
    }
    
    // MARK: Init & Deinit
    
    override init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.startAnimating()
    }
    
    deinit {
        self.stopAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.startAnimating()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.startAnimating()
    }
    
    // MARK: Private
    
    private var animateIndex: Int = 1

    private var animatedTimer: NSTimer?
    
    @objc private func animate () {
        if !self.hidden {
            self.setNeedsDisplay()
            self.animateIndex++
            if self.animateIndex > 8 {
                self.animateIndex = 1
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    
        let context = UIGraphicsGetCurrentContext()
        
        var startAngle = Config.CC_ARC_DRAW_PADDING
        for index in 1...8 {
            let arcPath = UIBezierPath()
            arcPath.addArcWithCenter(CGPointMake(CGFloat(self.frame.size.width/2), CGFloat(self.frame.size.height/2)), radius: CGFloat(Config.CC_ARC_DRAW_RADIUS), startAngle: CGFloat(DegreesToRadians(startAngle)), endAngle: CGFloat(DegreesToRadians(startAngle + Config.CC_ARC_DRAW_DEGREE)), clockwise: true)
            CGContextAddPath(context, arcPath.CGPath)
            startAngle += Config.CC_ARC_DRAW_DEGREE + (Config.CC_ARC_DRAW_PADDING * 2)
            
            CGContextSetLineWidth(context, CGFloat(Config.CC_ARC_DRAW_WIDTH))
            let colorIndex = abs(index - self.animateIndex)
            let strokeColor = Config.CC_ARC_DRAW_COLORS[colorIndex]
            CGContextSetStrokeColorWithColor(context, strokeColor)
            CGContextStrokePath(context)
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(CGFloat(Config.CC_ACTIVITY_INDICATOR_VIEW_WIDTH), CGFloat(Config.CC_ACTIVITY_INDICATOR_VIEW_WIDTH))
    }
    
    override func removeFromSuperview() {
        self.stopAnimating()
        super.removeFromSuperview()
    }
    
    override var hidden: Bool {
        didSet {
            if self.hidden {
                self.stopAnimating()
            }
        }
    }
}