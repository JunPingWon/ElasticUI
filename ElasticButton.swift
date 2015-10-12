//
//  ElasticButton.swift
//  ElasticUI
//
//  Created by JunpingWon on 15/10/12.
//  Copyright (c) 2015年 Daniel Tavares. All rights reserved.
//

import UIKit

class ElasticButton: UIButton {
    
    //拥有一个ElasticView的属性
    var elasticView  : ElasticView!
    //一个叫做overshootAmount的变量，它是IBInspectable类型，所以你可以通过Interface Builder灵活的控制它的值。重写了didSet方法，你只需设置弹性视图的overshootAmount的值就可以了
    @IBInspectable var overShootAmount : CGFloat = 10 {
        didSet{
            elasticView.overshootAmount = overShootAmount
        }
    }
    //两个标准的初始化方法，它们都调用可setupView()方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    
    func setUpView() {
        //设置clipsToBounds值为false,这可以是弹性视图的大小可以超过其父视图的大小，改变UITextfield的borderStyle属性为.None，使它变成扁平的
        clipsToBounds = false
        //创建一个ElasticView对象并添加到当前视图上作为子视图
        elasticView = ElasticView(frame: bounds)
        
        elasticView.backgroundColor = backgroundColor
        addSubview(elasticView)
        //改变当前视图的背景色为透明色，这样做的原因是让ElasticView决定视图的背景色
        backgroundColor = UIColor.clearColor()
        //设置ElasticView的userInteractionEnabled属性为false. 否则它将会触发当前视图的Touches事件
        elasticView.userInteractionEnabled = false
        
    }
    //重写touchesBegan方法，并将它传递到ElasticView，使它可以做动画
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        elasticView .touchesBegan(touches, withEvent: event)
    }
    

}
