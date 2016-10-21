//
//  HomeViewController.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/10/17.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

     //MARK: --属性
    var isPresented : Bool = false
     //MARK: --懒加载属性
    private lazy var titleBtn : TitleButton = TitleButton()
    private lazy var popoviewAnimator : PopoverAnimator = PopoverAnimator()
     //MARK: --系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.没有登录时设置的内容
        visitorView.addRotationAnim()
        if !isLogin {
        
            return
        }
        //2. 设置导航栏的内容
        setupNavigationBar()
    }

   
}

 //MARK: --设置UI界面
extension HomeViewController {
   
    private func setupNavigationBar() {
    
        //1.设置左侧的Item
        /*
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: ""), forState: .Normal)
        leftBtn.setImage(UIImage(named: ""), forState: .Highlighted)
        leftBtn.sizeToFit()
        */
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName:"navigationbar_friendattention")
        //2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        //3.设置titleview
        titleBtn.setTitle("archy", forState: .Normal)
        titleBtn.addTarget(self, action: "titilBtnClick:", forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleBtn
        
        
        
    }
}


 //MARK: --事件监听的函数
extension HomeViewController {

    @objc private func titilBtnClick(titleBtn : TitleButton ) {
    
        //1.改变按钮的状态
        titleBtn.selected = !titleBtn.selected
        
        //2.创建弹出的控制器
        let popoverVc = PopoverViewController()
        
        //3.设置控制器的modal样式
        popoverVc.modalPresentationStyle = .Custom
        
        //设置转场代理
        popoverVc.transitioningDelegate = popoviewAnimator
        //4.弹出控制器
        presentViewController(popoverVc, animated: true, completion: nil)
    }
}

 






















