//
//  CCLoadingView.swift
//  CCLoading
//
//  Created by Chun Ye on 12/10/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

import UIKit
import Foundation

struct Config {
    
    static let CC_ACTIVITY_INDICATOR_VIEW_NUMBEROFFRAMES: Int = 8
    static let CC_ACTIVITY_INDICATOR_VIEW_WIDTH: CGFloat = 40
    static let CC_ARC_DRAW_PADDING: CGFloat = 3.0
    static let CC_ARC_DRAW_DEGREE: CGFloat = 39.0
    static let CC_ARC_DRAW_WIDTH: CGFloat = 6.0
    static let CC_ARC_DRAW_RADIUS: CGFloat = 10.0
    static let CC_ARC_DRAW_COLORS = [UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor, UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).CGColor, UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor]
    
    static func CCActivityIndicatorViewFrameImage(frame: Int, _ scale: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(CC_ACTIVITY_INDICATOR_VIEW_WIDTH, CC_ACTIVITY_INDICATOR_VIEW_WIDTH), false, scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        var startDegree = Config.CC_ARC_DRAW_PADDING
        for index in 1...8 {
            let arcPath = UIBezierPath()
            let center  = CGPointMake(Config.CC_ACTIVITY_INDICATOR_VIEW_WIDTH / 2, Config.CC_ACTIVITY_INDICATOR_VIEW_WIDTH / 2)
            let startAngle = CGFloat(DegreesToRadians(Double(startDegree)))
            let endAngle = CGFloat(DegreesToRadians(Double(startDegree + Config.CC_ARC_DRAW_DEGREE)))
            arcPath.addArcWithCenter(center, radius: Config.CC_ARC_DRAW_RADIUS, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            CGContextAddPath(context, arcPath.CGPath)
            startDegree += Config.CC_ARC_DRAW_DEGREE + (Config.CC_ARC_DRAW_PADDING * 2)
            CGContextSetLineWidth(context, Config.CC_ARC_DRAW_WIDTH)
            let colorIndex = abs(index - frame)
            let strokeColor = Config.CC_ARC_DRAW_COLORS[colorIndex]
            CGContextSetStrokeColorWithColor(context, strokeColor)
            CGContextStrokePath(context)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

// MARK: Helpers

func DegreesToRadians (value: Double) -> Double {
    return value * M_PI / 180.0
}

// MARK: Activity Indicator View

@IBDesignable class CCActivityIndicatorView: UIView {
    
    @IBInspectable var hidesWhenStopped : Bool = true {
        didSet {
            if self.hidesWhenStopped {
                self.hidden = !self.animating
            } else {
                self.hidden = false
            }
        }
    }
    
    func startAnimating () {
        
        func animate () {
            self.animating = true
            self.hidden = false
            let animationDuration: CFTimeInterval = 0.8
            var animationImages = [CGImageRef]()

            for frame in 1...Config.CC_ACTIVITY_INDICATOR_VIEW_NUMBEROFFRAMES {
                animationImages.append(Config.CCActivityIndicatorViewFrameImage(frame, UIScreen.mainScreen().nativeScale).CGImage)
            }
            
            let animation = CAKeyframeAnimation(keyPath: "contents")
            animation.calculationMode = kCAAnimationDiscrete
            animation.duration = animationDuration
            animation.repeatCount = HUGE
            animation.values = animationImages
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeBoth
            self.layer.addAnimation(animation, forKey: "contents")
        }
        
        if !self.animating {
            animate()
        }
    }
    
    func stopAnimating () {
        self.animating = false
        
        self.layer.removeAnimationForKey("contents")
        self.layer.contents = Config.CCActivityIndicatorViewFrameImage(0, UIScreen.mainScreen().nativeScale).CGImage
        
        if self.hidesWhenStopped {
            self.hidden = true
        }
    }
    
    func isAnimating () -> Bool {
        return self.animating
    }
    
    // MARK: Init & Deinit
    
    override convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.startAnimating()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.startAnimating()
    }
    
    // MARK: Private
    
    private var animating = false
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(Config.CC_ACTIVITY_INDICATOR_VIEW_WIDTH, Config.CC_ACTIVITY_INDICATOR_VIEW_WIDTH)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(Config.CC_ACTIVITY_INDICATOR_VIEW_WIDTH, Config.CC_ACTIVITY_INDICATOR_VIEW_WIDTH)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.layer.bounds.size.width != Config.CC_ACTIVITY_INDICATOR_VIEW_WIDTH {
            self.layer.bounds = CGRectMake(0, 0, Config.CC_ACTIVITY_INDICATOR_VIEW_WIDTH, Config.CC_ACTIVITY_INDICATOR_VIEW_WIDTH)
        }
    }
}