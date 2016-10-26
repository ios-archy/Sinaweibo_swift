//
//  WelcomeViewController.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/26.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {
    
    // //MARK: --拖线的属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!

     //MARK: --系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        //0.设置头像
        let profileURLString = UserAccountViewModel.shareInstance.account?.avatar_large
        
        // ?? :r如果??前边的可选类型有值，那么将前面的可选类型进行解包并且赋值
        //如果??前面的类型为nil，那么直接使用??后面的值
        
        let url = NSURL(string: profileURLString ?? "")
        iconView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default_big"))
        iconView.layer.cornerRadius = 45
        iconView.layer.masksToBounds = true
        
        //1.改变约束的值
        iconViewBottomCons.constant = UIScreen.mainScreen().bounds.height - 200
        
        
        //2.执行动画
        //Damp :阻尼系数，阻尼系数越大，弹动的效果越不明显 0~1
        //initialSpringVelocity初始化速度
        UIView.animateWithDuration(5.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            
            self.view.layoutIfNeeded()
            
            }) { (_) -> Void in
                
                //3.将创建根控制器改成从main.storyboard加载
                UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }


  
}
