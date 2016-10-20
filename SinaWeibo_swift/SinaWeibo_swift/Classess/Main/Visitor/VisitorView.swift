//
//  VisitorView.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/10/19.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    // MARK:-  提供快速通过xib创建累的方法
    class func  visitorView() -> VisitorView {
    return NSBundle.mainBundle().loadNibNamed( "VisitorView" , owner: nil, options: nil ).first
        as! VisitorView
    }
     //MARK: --控件的属性
 
    @IBOutlet weak var RotationView: UIImageView!
    @IBOutlet weak var IconImage: UIImageView!
    @IBOutlet weak var TipsLable: UILabel!
    
    @IBOutlet weak var RegisterBtn: UIButton!
    @IBOutlet weak var LoginBtn: UIButton!
    
     //MARK: --自定义函数
    func setupVisitorViewInfo(iconName : String ,titile :String ){
    
        IconImage.image  = UIImage(named: iconName)
        TipsLable.text = titile
        RotationView.hidden = true
        
        
    }
    
    
    func addRotationAnim() {
    
        //1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        //2.设置动画的属性
        
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        rotationAnim.removedOnCompletion = false
        
        //3.将动画添加到layer中
        RotationView.layer.addAnimation(rotationAnim, forKey: nil)
    }
    
    
}
