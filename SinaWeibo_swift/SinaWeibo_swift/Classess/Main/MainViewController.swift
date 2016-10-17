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
//     addChildviewControllers()
        
        //1.获取json文件路径
        guard let jsonPath = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil) else {
        print("没有获取到对应的文件路径")
            return
        }
        
        //2.读取json文件的内容
        
        guard let jsonData = NSData(contentsOfFile: jsonPath) else
        {
        print("没有获取到json文件中数据")
            return
        }
        
        //3.将data转成数组
        //如果在调用系统某一个方法时，该方法最后有一个throws，说明该方法会抛出异常。如果一个方法会抛出异常，需要对异常进行处理
        //swift中提供三种处理异常的方法
        /*
        //方法一：try方式 程序员手动捕捉异常
//        do {
//         try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
//        }
//        catch {
//         print(error)
//        }
        
        //方式二：try?方式（常用方式）系统帮助我们处理异常，如果该方法出现了异常，则该方法返回nil，如果没有异常，则返回对应的对象
//        guard let anyObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) else {
//        return
//        }
        
        
        //方法三：try!方法（不建议，非常危险）直接告诉系统，该方法没有异常，注意：如果该方法出现了异常，那么程序会报错（崩溃）
//        let anyObject = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
         */
        
        guard let anyObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) else
        {
            return
        }
        
        guard let dictArray = anyObject as? [[NSString :AnyObject]] else {
        
            return
        }
        
        //4.遍历字典获取对应的信息
        for dict in dictArray {
        
            //4.1获取控制器的对应的字符串
            guard let vcName = dict["vcName"] as? String else
            {
                continue
            }
            
            guard let title = dict["title"] as? String else {
              continue
             }
            
            guard let imageName = dict["imageName"] as? String else {
            continue
            }
             addChildViewController(vcName, title: title, imageName: imageName)
            
        }
        
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