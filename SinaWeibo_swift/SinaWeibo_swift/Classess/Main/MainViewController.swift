//
//  MainViewController.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/10/17.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
     addChildviewControllers()
        
    }


    
}

extension MainViewController {

  func  addChildviewControllers()
    {
    addChildViewController(HomeViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(MessageViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(DisCoverViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(ProfileViewController(), title: "我", imageName: "tabbar_profile")
    }
}

extension MainViewController {

    private func addChildViewController(childVC: UIViewController , title :String , imageName : String) {
        
        //设置自控制器的属性
        childVC.title = title;
        childVC.tabBarItem.image = UIImage(named: imageName)
        childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        //2.包装导航控制器
        let childNav = UINavigationController(rootViewController: childVC)
        
        //3.添加控制器
        addChildViewController(childNav)
    }

}