//
//  ComposeTextView.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/11/6.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit
import SnapKit


class ComposeTextView: UITextView {

    // MARK:-懒加载属性
     lazy var placeHoderLabel : UILabel = UILabel()
    
    // MARK:- 构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
}

extension ComposeTextView {

    private func setupUI() {
     //1.添加子控件
        addSubview(placeHoderLabel)
        
        //2.设置frame
        placeHoderLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        //3.设置placeHoderLabel属性
        placeHoderLabel.textColor = UIColor.lightGrayColor()
        placeHoderLabel.font = font
        
        //4.设置placeHoderLabel文字
        placeHoderLabel.text = "分享新鲜事。。。"
        //5.设置内容的内边距
        textContainerInset = UIEdgeInsets(top: 6, left: 7, bottom: 0, right: 7)
    }
}