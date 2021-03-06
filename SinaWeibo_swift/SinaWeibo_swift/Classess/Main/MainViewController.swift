//
//  MainViewController.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/10/17.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    private lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          setUpcenterBtn()
        
        }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    
    }

}

//Mark:--设置UI界面
extension MainViewController {
    /**
     设置发布按钮
     */
    private func setUpcenterBtn() {
    
        //1.添加到tabbar中
        tabBar.addSubview(composeBtn)
      
        //2.设置位置
        composeBtn.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height * 0.5)
        
        //3.监听发布按钮的点击
        //Selector两种写法：1。Selector()括号里放字符串 ：Selector("composeBtnClick")  2.直接传字符串："composeBtnClick"
        composeBtn.addTarget(self, action: "composeBtnClick", forControlEvents: .TouchUpInside)
    }
}

//MARK:--事件监听

extension MainViewController {
//事件监听本质是发送消息，但是发送消息是OC的特性
    //将方法包装秤@SEL-->类中查找方法列表-->根据@SEL找到imp指针（函数）->>执行函数
    //如果swift中将一个函数申明为private，那么该函数不会被添加到方法列表
    //如果在priv 前面加上objc，那么该方法依然会被添加到方法列表中
 @objc private  func composeBtnClick(){
    
     //1.创建发布控制器
    let compseVc = ComposeViewController()
    
    //2.包装导航控制器
    let composeNav = UINavigationController(rootViewController: compseVc)
    
    //3.弹出控制器
    presentViewController(composeNav, animated: true, completion: nil)
    }

}



//extension MainViewController
//{
//
//    //Mark :懒加载属性
//    private lazy var imageNames = ["tabbar_home","tabbar_message_center","","tabbar_discover","tabbar_profile"]
//    func addTabbarImage() {
//        //1.遍历所有的Item
//        for  i in 0..<tabBar.items!.count
//        {
//            //2.获取item
//            let item = tabBar.items![i]
//            //3.如果是下标值为2，则该item不可以和用户交互
//            if i == 2 {
//                item.enabled = false
//                continue
//            }
//            
//            //4.设置其他item的选中时候的图片
//            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
//        }
//        
//
//    }
//}

//// MARK: - 一下文件都没啥用了
//extension MainViewController {
//
//    func addchildController (){
//    
//        //1.获取json文件路径
//        guard let jsonPath = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil) else {
//            print("没有获取到对应的文件路径")
//            return
//        }
//        
//        //2.读取json文件的内容
//        
//        guard let jsonData = NSData(contentsOfFile: jsonPath) else
//        {
//            print("没有获取到json文件中数据")
//            return
//        }
//        
//        //3.将data转成数组
//        //如果在调用系统某一个方法时，该方法最后有一个throws，说明该方法会抛出异常。如果一个方法会抛出异常，需要对异常进行处理
//        //swift中提供三种处理异常的方法
//        /*
//        //方法一：try方式 程序员手动捕捉异常
//        //        do {
//        //         try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
//        //        }
//        //        catch {
//        //         print(error)
//        //        }
//        
//        //方式二：try?方式（常用方式）系统帮助我们处理异常，如果该方法出现了异常，则该方法返回nil，如果没有异常，则返回对应的对象
//        //        guard let anyObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) else {
//        //        return
//        //        }
//        
//        
//        //方法三：try!方法（不建议，非常危险）直接告诉系统，该方法没有异常，注意：如果该方法出现了异常，那么程序会报错（崩溃）
//        //        let anyObject = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
//        */
//        
//        guard let anyObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) else
//        {
//            return
//        }
//        
//        guard let dictArray = anyObject as? [[NSString :AnyObject]] else {
//            
//            return
//        }
//        
//        //4.遍历字典获取对应的信息
//        for dict in dictArray {
//            
//            //4.1获取控制器的对应的字符串
//            guard let vcName = dict["vcName"] as? String else
//            {
//                continue
//            }
//            
//            guard let title = dict["title"] as? String else {
//                continue
//            }
//            
//            guard let imageName = dict["imageName"] as? String else {
//                continue
//            }
//            addChildViewController(vcName, title: title, imageName: imageName)
//            
//        }
//        
//
//    }
//}
//
//extension MainViewController {
//
//  func  addChildviewControllers()
//    {
//    addChildViewController("HomeViewController", title: "首页", imageName: "tabbar_home")
//        addChildViewController("MessageViewController", title: "消息", imageName: "tabbar_message_center")
//        addChildViewController("DisCoverViewController", title: "发现", imageName: "tabbar_discover")
//        addChildViewController("ProfileViewController", title: "我", imageName: "tabbar_profile")
//    }
//}
//
//extension MainViewController {
//
//    private func addChildViewController(childVCname: String , title :String , imageName : String) {
//        //0.获取命名空间
//        guard let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String
//        else {
//        print("没有获取到命名空间")
//            return
//        }
//        
//        //1.根据字符串获取对应的Class
//        guard let ChildVcClass = NSClassFromString(nameSpace + "." + childVCname)
//        else
//        {
//            print("没有获取到字符串对应的class")
//            return
//        }
//        
//        //2.将对应的AnyObject转成控制器的类型
//        
//        guard let childVcType = ChildVcClass as? UIViewController.Type else {
//         print("没有获取对应控制器类型")
//            return
//        }
//        //3.创建对应控制器对象
//        let childVC = childVcType.init()
//        
//        //4.设置自控制器的属性
//        childVC.title = title;
//        childVC.tabBarItem.image = UIImage(named: imageName)
//        childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
//        
//        //2.包装导航控制器
//        let childNav = UINavigationController(rootViewController: childVC)
//        
//        //3.添加控制器
//        addChildViewController(childNav)
//    }
//
//}