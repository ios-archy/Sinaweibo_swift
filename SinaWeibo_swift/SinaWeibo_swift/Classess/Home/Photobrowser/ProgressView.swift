//
//  ProgressView.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/11/21.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class ProgressView: UIView {


     //MARK: --定义属性
    var progress : CGFloat = 0 {
    
        didSet {
        
            setNeedsDisplay()
        }
    }
    
     //MARK: --重写drawrect方法
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        //获取参数
        let center = CGPoint(x: rect.width, y: rect.height * 0.8)
        let radius =  rect.width * 0.5 - 3
        let startAngel = CGFloat(-M_PI_2)
        let endAngel = CGFloat(2 * M_PI) * progress + startAngel
        
        //创建贝塞尔曲线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngel, endAngle: endAngel, clockwise: true)
        
        //绘制一条中心点的线
        path.addLineToPoint(center)
        path.closePath()
        
        //设置绘制的颜色
        UIColor(white: 1.0, alpha: 0.4).setFill()
        
        //开始绘制
        path.fill()
    }

}
