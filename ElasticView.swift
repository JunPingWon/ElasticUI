//
//  ElasticView.swift
//  ElasticUI
//
//  Created by JunpingWon on 15/10/10.
//  Copyright (c) 2015年 Daniel Tavares. All rights reserved.
//

import UIKit



class ElasticView: UIView {
    
    private let topControlPointView = UIView()
    private let leftControlPointView = UIView()
    private let bottomControlPointView = UIView()
    private let rightControlPointView = UIView()
    
    private let elasticShape = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
        positionControlPoints()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupComponents()
        positionControlPoints()

    }
    
//  setUpComponents()是一个配置方法，它会在所有的初始化方法中调用
    private func setupComponents() {
        //设置图形的图层填充色和ElasticView的背景色一致，填充的路径和视图的边界一致
        elasticShape.fillColor = backgroundColor?.CGColor
        backgroundColor = UIColor.clearColor()
        clipsToBounds = false
        elasticShape.path = UIBezierPath(rect: self.bounds).CGPath
        //添加到当前视图的图层结构上
        layer.addSublayer(elasticShape)
        
        //添加4个控制点
        for controlPoint in[topControlPointView,leftControlPointView,bottomControlPointView,rightControlPointView]{
            addSubview(controlPoint)
            
            controlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
//            controlPoint.backgroundColor = UIColor.blueColor()
        }
        
        
    }
    
    //四个控制点分别在上、左、下、右边界的中心位置
    private func positionControlPoints() {
        
        topControlPointView.center = CGPoint(x: bounds.midX, y: 0.0)
        leftControlPointView.center = CGPoint(x: 0.0, y: bounds.midY)
        bottomControlPointView.center = CGPoint(x: bounds.midX, y: bounds.maxY)
        rightControlPointView.center = CGPoint(x: bounds.maxX, y: bounds.midY)
    }
    
    
    private func bezierPathForControlPoints()->CGPathRef {
        // 1
        let path = UIBezierPath()
        
        // 2
        let top = topControlPointView.layer.presentationLayer().position
        let left = leftControlPointView.layer.presentationLayer().position
        let bottom = bottomControlPointView.layer.presentationLayer().position
        let right = rightControlPointView.layer.presentationLayer().position
        
        let width = frame.size.width
        let height = frame.size.height
        
        // 3
        path.moveToPoint(CGPointMake(0, 0))
        path.addQuadCurveToPoint(CGPointMake(width, 0), controlPoint: top)
        path.addQuadCurveToPoint(CGPointMake(width, height), controlPoint:right)
        path.addQuadCurveToPoint(CGPointMake(0, height), controlPoint:bottom)
        path.addQuadCurveToPoint(CGPointMake(0, 0), controlPoint: left)
        
        // 4
        return path.CGPath
    }
    //每次更新都会调用的方法
    func updateLoop() {
        elasticShape.path = bezierPathForControlPoints()
    }
    //CADisplayLink 对象是一个定时器，它允许应用程序的活动和显示器的刷新率同步。你只需要添加一个target和一个action，那么当屏幕的内容更新的时候，action方法将会被调用。
    private lazy var displayLink : CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: Selector("updateLoop"))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        return displayLink
        }()
    
    private func startUpdateLoop() {
        displayLink.paused = false
    }
    
    private func stopUpdateLoop() {
        displayLink.paused = true
    }
    
    //使用 @IBInspectable声明的每一个变量，都可以在Interface Builder界面上看到一个输入框，在这个输入框里可以设置它的值。
    @IBInspectable var overshootAmount : CGFloat = 10
    
    func animateControlPoints() {
        //1
        let overshootAmount  = self.overshootAmount
        // 2
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.5,
            options: nil, animations: {
                // 3
                self.topControlPointView.center.y -= overshootAmount
                self.leftControlPointView.center.x -= overshootAmount
                self.bottomControlPointView.center.y += overshootAmount
                self.rightControlPointView.center.x += overshootAmount
            },
            completion: { _ in
                // 4
                UIView.animateWithDuration(0.45, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 5.5,
                    options: nil, animations: {
                        // 5
                        self.positionControlPoints()
                    },
                    completion: { _ in
                        // 6
                        self.stopUpdateLoop()
                })
        })
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        startUpdateLoop()
        animateControlPoints()
    }

    override var backgroundColor : UIColor? {
        willSet {
            if let newValue = newValue {
                elasticShape.fillColor = newValue.CGColor
                super.backgroundColor = UIColor.clearColor()
            }
        }
    
    }
    
    
    
    
    
    
}
