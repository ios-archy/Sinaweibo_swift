//
//  ComposeTitleView.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/11/6.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTitleView: UIView {
    
    
    // MARK:- 懒加载属性
    private lazy var titleLable : UILabel = UILabel()
    private lazy var screenNameLable :UILabel = UILabel()
    
    // MARK:-构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder :NSCoder)
    {
    fatalError("init(coder:) has not been")
    }
}


//MARK:--设置UI界面
extension ComposeTitleView {

    private func setupUI() {
    //1.将子控件添加到view中
        addSubview(titleLable)
        addSubview(screenNameLable)
        
        //2.设置frame
        titleLable.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        
        screenNameLable.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(titleLable.snp_centerX)
            make.top.equalTo(titleLable.snp_bottom).offset(3)
        }
        
        //3.设置空间的属性
        titleLable.font = UIFont.systemFontOfSize(16)
        screenNameLable.font = UIFont.systemFontOfSize(14)
        screenNameLable.textColor = UIColor.lightGrayColor()
        
        //4.设置文字内容
        titleLable.text = "发微博"
        screenNameLable.text = UserAccountViewModel.shareInstance.account?.screen_name
    
    }
    
}









