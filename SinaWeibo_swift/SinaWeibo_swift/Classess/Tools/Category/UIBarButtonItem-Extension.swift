//
//  UIBarButtonItem-Extension.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/20.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

 extension UIBarButtonItem {
    
    /*
    convenience init(imageName : String){
    
    self.init()
    let btn = UIButton()
    btn.setImage(UIImage(named: ""), forState: .Normal)
    btn.setImage(UIImage(named: ""), forState: .Selected)
    btn.sizeToFit()
    self.customView = btn
    }
    */
    
    convenience init(imageName :String) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: imageName), forState: .Selected)
        btn.sizeToFit()
        self.init(customView :btn)
    }
}

