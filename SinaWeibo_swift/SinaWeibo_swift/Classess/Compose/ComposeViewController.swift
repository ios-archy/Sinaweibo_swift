//
//  ComposeViewController.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/11/5.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    // MARK:-懒加载属性
    private lazy var titleView : ComposeTitleView = ComposeTitleView()

    @IBOutlet weak var textView: ComposeTextView!
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //设置导航栏
        setupNavigationBar()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

}

extension ComposeViewController {

    private func setupNavigationBar (){
    
    //1.设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: "closeItemClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: "sendItemClick")
        navigationItem.rightBarButtonItem?.enabled = false
        
        //2。设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
}

extension ComposeViewController {

    @objc private func closeItemClick(){
    dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func sendItemClick(){
    print("sendItemClick")
    }
}

//MARK :-UItextview的代理方法
extension ComposeViewController : UITextViewDelegate {

    func textViewDidChange(textView: UITextView) {
        self.textView.placeHoderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}