//
//  User.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/26.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class User: NSObject {
     //MARK: --属性
    var profile_image_url : String? //用户的头像
    
    var screen_name : String?       //用户的昵称
    
    var verified_type : Int = -1  {
    
        didSet {
            
            switch verified_type {
            
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default :
                verifiedImage = nil
            
            }
        
        }
        
    }  //用户的认证类型
    
    var mbrank : Int = 0   { // 用户的的会员等级
    
        didSet{
            if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    
    
     //MARK: --对用户的数据处理
    var verifiedImage : UIImage?
    var vipImage : UIImage?
    
    
     //MARK: --自定义构造函数
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
