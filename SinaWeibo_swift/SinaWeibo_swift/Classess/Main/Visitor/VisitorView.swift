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

}
