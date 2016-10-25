//
//  OAuthViewController.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/25.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit
import SVProgressHUD
class  OAuthViewController :UIViewController{
    
     //MARK: --控件的属性
    
    @IBOutlet weak var webView: UIWebView!
    
    
     //MARK: --系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.设置导航栏的内容
        setupNavtigationBar()
        //2.加载网页
        loadPage()
    }
    
}


 //MARK: --设置UI界面先关
extension OAuthViewController {

    
    private func setupNavtigationBar(){
    
        //1.设置左侧的item
        
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: "closeItemClick");
        
        //2.右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: "filleItemClick")
        
        //3.设置标题
        title = "登录界面"
    }
    
    
    private func loadPage(){
    
        //1.获取登录页面的URLStrin
        let urlString =  "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        //2.创建对应NSURL
        guard let url = NSURL(string: urlString) else {
        return
        }
        
        //3.创建NSURLRequest对象
        let requst = NSURLRequest(URL: url)
        
        webView.delegate = self
        
        //4.加载request对象
        webView.loadRequest(requst)
    }
}


extension OAuthViewController {

    @objc private func closeItemClick() {
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func filleItemClick() {
        //1.书写js代码
        let jsCode = "document.getElementById('userId').value='1606020376@qq.com';document.getElementById('passwd').value='haomage';"
        //2.执行js代码
        webView.stringByEvaluatingJavaScriptFromString(jsCode)
        print("filleItemClick")
    }

    
}

extension OAuthViewController : UIWebViewDelegate {

    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
    
    //当准备加载某一个页面是，会执行该方法
    //返回值：true -> 继续加载页面 false -> 不加载该页面
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
         //MARK: --获取加载网页的NSURL
        guard let url = request.URL else {
          return true
        }
        
        //2.获取url中的字符串
        let urlString  = url.absoluteString
        
        //3.判断该字符串中是否包含code
        guard urlString.containsString("code=") else {
        
            return true
        }
        
        //4.将code截取出来
        
        let code = urlString.componentsSeparatedByString("code=").last!
        
//        print("-------\(code)")
        
        //5.请求AccessToken
        loadAcessToken(code)
        return false
    }
 
    
}

extension OAuthViewController {


    //请求AccessToken
    private func loadAcessToken (code : String) {
    
        NetworkTools.shareInstance.loadAccessToken(code) { (result, error) -> () in
            
            //1.错误校验
            if error != nil {
              print(error)
              return
            }
            
            //2.拿到结果
            guard let accountDict = result else {
            
                print("没有获取授权后的数据")
                return
            }
            
            //3.将字典转成模型对象
            let account = UserAccount(dict: accountDict)
            
            //4.请求用户信息
            self.loadUserInfo(account)
        }
    }
    
    
  //MARK: -- 请求用户信息
    private func  loadUserInfo(account : UserAccount) {
    
        //1.获取access——token
        guard let accessToken = account.access_token else {
        return
        }
        
        //2.回去uid
        
        guard let uid = account.uid else {
         return
        }
        
        
        //3.发送网络请求
        NetworkTools.shareInstance.loadUserInfo(accessToken, uid: uid) { (result, error) -> () in
            //1.错误校验
            if error != nil {
             print(error)
                return
            }
            //2.拿到用户信心的结果
            guard let userInfoDict = result else {
            return
            }
            
            //3.从字典中去除昵称和用户头像地址
            
            account.screen_name = userInfoDict["screen_name"] as? String
            
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            print(account)
        }
    }
}
