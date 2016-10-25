//
//  NetworkTools.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/25.
//  Copyright © 2016年 archy. All rights reserved.
//

import AFNetworking

enum RequestType : String {

    case GET = "GET"
    case POST = "POST"
    
}

class  NetworkTools :AFHTTPSessionManager {
    
    //let 是线程安全的
    static let shareInstance : NetworkTools = {
    
    let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
     
    }()
}


 //MARK: --封装请求方法
extension NetworkTools {

    func request(methodType : RequestType ,urlString : String, parameters :[ String :AnyObject],finished : (result : AnyObject? ,error :NSError?)-> ()){
     //1.定义成功的回调闭包
        let successCallBack = { (task :NSURLSessionDataTask ,result : AnyObject?) -> Void in
         finished (result :result ,error: nil)
        }
       
        //2.定义失败的回调闭包
        let failureCallBack = { (task :NSURLSessionDataTask? ,error : NSError) -> Void in
        
            finished(result: nil, error: error)
        }
        
        //3.发送网络请求
        if methodType == .GET
        {
             GET(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }else
        {
            POST(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

 //MARK: --请求AccessToken
extension NetworkTools {
    func loadAccessToken (code :String ,finished :(result : [String : AnyObject]? ,error :NSError?) -> ()){
    
    //1.获取请求的urlString 
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        //2.获取请求的参数
        let parameters = ["client_id" : app_key ,"client_secret" : app_secret ,"grant_type" : "authorization_code" ,"redirect_uri" : redirect_uri ,"code" : code]
        
        //3.发送网络请求
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) -> () in
            finished(result: result as? [String : AnyObject], error: error)
        }
    }

}


extension NetworkTools {

    func loadUserInfo (access_token : String ,uid :String ,finished :(result :[String :AnyObject]?,error :NSError?)->()){
    
        //1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        //2.获取请求的参数
        let parameters = ["access_token" : access_token,"uid" : uid]
        
        //3.发送网络请求
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) -> () in
            finished(result: result as? [String : AnyObject], error: error)
        }
    }
    
}
