//
//  Status.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/26.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit


class Status : NSObject {
    
     //MARK: --属性
    var created_at : String? //微博创建时间
    var source : String?     //微博来源
    var text :String?        //微博正文
    var mid : Int = 0        //微博的id
    var user : User?
    
     //MARK: --对数据的处理的属性
    var sourceText : String?
    var createAtText : String?
    
    init(dict :[String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
        
        if let userDict = dict["user"] as? [String : AnyObject] {
            user  = User(dict:userDict)
        }
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
