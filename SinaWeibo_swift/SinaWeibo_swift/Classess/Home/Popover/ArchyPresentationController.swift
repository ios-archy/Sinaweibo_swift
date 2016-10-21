//
//  ArchyPresentationController.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/21.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class ArchyPresentationController: UIPresentationController {

    
     //MARK: --懒加载属性
    private lazy var coverView  = UIView()
    
     //MARK: --系统回调函数
    override func containerViewWillLayoutSubviews() {
        
        super.containerViewWillLayoutSubviews()
        
        //1.设置弹出View的尺寸
        presentedView()?.frame = CGRect(x: 100, y: 55, width: 180, height: 250)
        
        //2.添加蒙版
        setupCoverView()
    }
    
}

extension ArchyPresentationController
{

    private func setupCoverView() {
      //1.添加蒙版
        containerView?.insertSubview(coverView, atIndex: 0)
        
        //2.设置蒙版属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        
        //3.添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: "coverViewClick")
        coverView.addGestureRecognizer(tapGes)
        
    }
}

extension ArchyPresentationController
{
    @objc private func coverViewClick(){
    
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}