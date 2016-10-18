//
//  AppDelegate.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/10/17.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //设置全局颜色
        UITabBar.appearance().tintColor = UIColor.orangeColor()
//
//        //创建Window
//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        window?.backgroundColor = UIColor.whiteColor()
//        window?.rootViewController = MainViewController()
//        window?.makeKeyAndVisible()
        return true
    }

    

}

