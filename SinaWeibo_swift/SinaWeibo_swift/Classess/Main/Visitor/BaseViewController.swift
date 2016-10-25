//
//  BaseViewController.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/10/19.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    // MARK:- 懒加载
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    // MARK:- 定义变量
    var isLogin : Bool = false
    
    // MARK:- 系统调用函数
    override func loadView() {
        isLogin ? super.loadView() : setUpVisitorView()
    }
    override func viewDidLoad() {
         super.viewDidLoad()
        setUpNavigationItems()
    }

}

 //MARK: --设置UI界面
extension BaseViewController
{
//设置方可视图
    private func setUpVisitorView() {
    
        view = visitorView
        //监听访客视图“注册”和“登录按钮的点击”
        visitorView.RegisterBtn.addTarget(self, action: "registerBtnClick", forControlEvents: .TouchUpInside)
        visitorView.LoginBtn.addTarget(self, action: "loginBtnClick", forControlEvents: .TouchUpInside)
    }
    
    /**
    *  设置导航栏左右的Item
    */
    private func setUpNavigationItems(){
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: "registerBtnClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: .Plain, target: self, action: "loginBtnClick")
    }
}

 //MARK: --事件监听
extension BaseViewController {

    @objc private func registerBtnClick(){
    
        print("registerBtnClick")
    }
    
    @objc private func loginBtnClick(){
    
         print("loginBtnClick")
        //1.创建授权控制器
        
        let oauthVc = OAuthViewController()
        
        //2.包装导航控制器
        
        let oauthNav = UINavigationController(rootViewController: oauthVc)
        
        //3.弹出控制器
        presentViewController(oauthNav, animated: true, completion: nil)
    }

}




