//
//  UserAccountViewModel.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/26.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit


class UserAccountViewModel  {
    
    
     //MARK: --将类设计成单例
    static let shareInstance : UserAccountViewModel = UserAccountViewModel()
    
    
     //MARK: --定义属性
    var account : UserAccount?
    
     //MARK: --计算属性
    var accountPath : String {
    
        let accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        return (accountPath as NSString).stringByAppendingPathComponent("accunt.plist")
    }
    
    var isLogin : Bool {
    
        if account == nil {
        return false
        }
        
        guard let expiresDate = account?.expires_date else {
        return false
        }
        
        return expiresDate.compare(NSDate()) == NSComparisonResult.OrderedDescending
    }
    
    
     //MARK: --重写init（）函数
    init() {
    
        //从沙盒中读取归档的信息
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
    }
}
