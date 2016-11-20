//
//  UIButton-Extension.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/10/19.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

extension UIButton {

//swift中类方法是以class开头的方法，类似于 OC中+开头的方法
    
//    class func createButton(imageName: String ,bgImageName : String) ->UIButton {
//        //1.创建btn
//        let btn = UIButton()
//        btn.setImage(UIImage(named: imageName), forState: .Normal)
//        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Selected)
//        btn.setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
//        btn.setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), forState: .Selected)
//        btn.sizeToFit()
//        return btn
//    }
    //convenience  便利：使用convenience修饰的构造函数叫做便利构造函数
    //遍历构造函数通常用在对系统的类进行构造函数的扩充时使用
    /*
 遍历构造函数的特点
    1.遍历构造函数通常写在extension里面
    2.遍历构造函数init前面需要加载convenience
    3.遍历构造函数内部必须调用self.init()
      */
   convenience init(imageName: String ,bgImageName : String)
       {
         self.init()
        setImage(UIImage(named: imageName), forState: .Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: .Selected)
        setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), forState: .Selected)
        sizeToFit()
      }
    
    convenience init(bgColor : UIColor ,fontsize : CGFloat ,titel :String ) {
    
        self.init()
        setTitle(titel, forState: .Normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFontOfSize(fontsize)
    }
}