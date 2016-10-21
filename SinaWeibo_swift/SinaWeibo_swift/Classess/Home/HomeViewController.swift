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
        popoverVc.transitioningDelegate = self
        //4.弹出控制器
        presentViewController(popoverVc, animated: true, completion: nil)
    }
}

 //MARK: --自定义转场代理的方法
extension HomeViewController :UIViewControllerTransitioningDelegate {

    //目的：改变弹出View的尺寸
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return ArchyPresentationController(presentedViewController: presented,presentingViewController: presenting)
    }
    
    //目的：自定义弹出的动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    //目的:自定义消失的动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}



 //MARK: --弹出和消失动画代理的方法
extension HomeViewController :   UIViewControllerAnimatedTransitioning {

    
    /**
    *  动画执行的时间
    */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    
    //获取转场上下文：可以通过转场上下文获取弹出的view和消失的view
    // UITransitionContextFromViewKey : 获取消失的View
    // UITransitionContextToViewKey : 获取弹出的View
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? animationForPresentedView( transitionContext ) : animationForDismissedView( transitionContext )
    }
    
    
    
    /**
    *  自定义弹出动画
    */
    private func animationForPresentedView(transitionContext :UIViewControllerContextTransitioning)
    {
        
        //1.获取弹出的view
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        //2.将弹出的View添加到ContainerView中
        transitionContext.containerView()?.addSubview(presentedView)
        
        //3.执行动画
        presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        presentedView.layer.anchorPoint = CGPointMake(0.5, 0)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            presentedView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                //必须告诉转场上下文你已经完成动画
                transitionContext.completeTransition(true)
        }
        
        
    }
    
    /**
    *  自定义消失动画
    */
    private func animationForDismissedView(transitionContext : UIViewControllerContextTransitioning) {
    
        //1.获取消失的View
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        //2.执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            dismissView?.transform = CGAffineTransformMakeScale(1.0, 0.00001)
            }) { (_) -> Void in
                dismissView?.removeFromSuperview()
                //必须告诉转场上下文你已经完成了动画
                transitionContext.completeTransition(true)
        }
    }
    
    
}

























