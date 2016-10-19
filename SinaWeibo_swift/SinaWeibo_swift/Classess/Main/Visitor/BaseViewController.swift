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
    }

}

extension BaseViewController
{

    private func setUpVisitorView() {
    
        view = visitorView
    }
}