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
    //注意:在闭包中如果使用当前对象的属性或者调用方法，也需要加self
    //两个地方需要使用self :1>如果在一个函数总出现歧义 2>在比保重使用当前对象的属性方法也需要
    private lazy var popoviewAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) -> () in
        self?.titleBtn.selected = presented
    }
    
    private lazy var ViewModels : [StatusViewModel] = [StatusViewModel]()
    
    
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
        
        //3.请求数据
        loadStatues()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 200
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
        popoviewAnimator.presentedFrame  = CGRect(x: 100, y: 60, width: 180, height: 250)
        //4.弹出控制器
        presentViewController(popoverVc, animated: true, completion: nil)
    }
}


 //MARK: --请求数据
extension HomeViewController {
    private func loadStatues(){
    
    NetworkTools.shareInstance.loadStatuese { (result, error) -> () in
        
            //1.错误校验
            if error != nil {
              print(error)
                return
              
              }
            //2.获取可选类型中的数据
            guard let resultArray = result else {
             return
            }
            
            //3.遍历微博对应的字典
            
            for statusDict in resultArray {
              let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                self.ViewModels.append(viewModel)
             }
        
            //4.刷新表格
            self.tableView.reloadData()
                
            }
    }

}



 //MARK: --tableview的数据源方法
extension HomeViewController {

  override    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModels.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //1.创建cell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell") as! HomeViewCell
        
        //2.给cell设置数据
        let viewmodel = ViewModels[indexPath.row]
        cell.viewModel = viewmodel
        
        return cell
    }
}

















