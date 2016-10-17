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
    addChildViewController("HomeViewController", title: "首页", imageName: "tabbar_home")
        addChildViewController("MessageViewController", title: "消息", imageName: "tabbar_message_center")
        addChildViewController("DisCoverViewController", title: "发现", imageName: "tabbar_discover")
        addChildViewController("ProfileViewController", title: "我", imageName: "tabbar_profile")
    }
}

extension MainViewController {

    private func addChildViewController(childVCname: String , title :String , imageName : String) {
        //0.获取命名空间
        guard let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String
        else {
        print("没有获取到命名空间")
            return
        }
        
        //1.根据字符串获取对应的Class
        guard let ChildVcClass = NSClassFromString(nameSpace + "." + childVCname)
        else
        {
            print("没有获取到字符串对应的class")
            return
        }
        
        //2.将对应的AnyObject转成控制器的类型
        
        guard let childVcType = ChildVcClass as? UIViewController.Type else {
         print("没有获取对应控制器类型")
            return
        }
        //3.创建对应控制器对象
        let childVC = childVcType.init()
        
        //4.设置自控制器的属性
        childVC.title = title;
        childVC.tabBarItem.image = UIImage(named: imageName)
        childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        //2.包装导航控制器
        let childNav = UINavigationController(rootViewController: childVC)
        
        //3.添加控制器
        addChildViewController(childNav)
    }

}