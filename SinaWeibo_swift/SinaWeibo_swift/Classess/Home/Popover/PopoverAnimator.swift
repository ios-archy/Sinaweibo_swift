//
//  PopoverAnimator.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/21.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {

     //MARK: --对外提供属性
    var isPresent : Bool = false
    
    var presentedFrame : CGRect = CGRectZero
    
    var callBack :((presented :Bool) -> ())?
    
     //MARK: --自定义构造函数
    //注意：如果自定义了一个构造函数，但是没有对默认构造函数init()重写。那么自定义一构造函数会覆盖默认的init()构造函数
    init(callBack : (presented : Bool) -> ()) {
        self.callBack = callBack
    }
}


 //MARK: --自定义转场代理的方法
extension PopoverAnimator : UIViewControllerTransitioningDelegate {

    //目的：改变弹出的view的尺寸
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return ArchyPresentationController(presentedViewController : presented ,presentingViewController: presenting )
        
    }
    
    // //MARK: --目的：自定义弹出的动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
         return self
    }
    
    
     //MARK: --自定义消失的动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}

 //MARK: --弹出和消失动画代理的方法
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {

    /**
    *  动画执行的时间
    */
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    
    //
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        isPresent ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
    }
    
    
    //自定义弹出动画
    private func animationForPresentedView(transitonContext : UIViewControllerContextTransitioning) {
    //1.获取弹出的view
        let presentedView = transitonContext.viewForKey(UITransitionContextToViewKey)!
        
        //2.将弹出的view添加到contaninerView中
        transitonContext.containerView()?.addSubview(presentedView)
        
        
        //3.执行动画
        presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        presentedView.layer.anchorPoint = CGPointMake(0.5, 0)
        UIView.animateWithDuration(transitionDuration(transitonContext), animations: { () -> Void in
            presentedView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                //必须告诉转场上下文你已经完成动画
                transitonContext.completeTransition(true)
        }
        
    
    }
    
    /**
    *  自定义消失动画
    */
    private func animationForDismissedView(transitionContext : UIViewControllerContextTransitioning) {
    //1.获取消失view
        let dismissView  = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        //2.执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            dismissView?.transform = CGAffineTransformMakeScale(1.0, 0.00001)
            }) { (_) -> Void in
                dismissView?.removeFromSuperview()
                //必须告诉转场上下文你已经完成动画
                transitionContext.completeTransition(true)
        }
    }
}












