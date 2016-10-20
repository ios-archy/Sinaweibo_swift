//
//  DisCoverViewController.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/10/17.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class DisCoverViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       visitorView.setupVisitorViewInfo("visitordiscover_image_message", titile: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }


}
