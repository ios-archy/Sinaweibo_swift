//
//  HomeViewController.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/10/17.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
class HomeViewController: BaseViewController {

     //MARK: --属性
    var isPresented : Bool = false
     //MARK: --懒加载属性
    private lazy var titleBtn : TitleButton = TitleButton()
    //注意:在闭包中如果使用当前对象的属性或者调用方法，也需要加self
    //两个地方需要使用self :1>如果在一个函数总出现歧义 2>在比保重使用当前对象的属性方法也需要
    private lazy var popoviewAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) -> () in
        self?.titleBtn.selected = presented
    }
    
    private lazy var ViewModels : [StatusViewModel] = [StatusViewModel]()
    
    private lazy  var tipLabel : UILabel = UILabel()
    
    private lazy var photoBrowserAnimator  : PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    
     //MARK: --系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.没有登录时设置的内容
        visitorView.addRotationAnim()
        if !isLogin {
        
            return
        }
        //2. 设置导航栏的内容
        setupNavigationBar()
        
        //3.设置高度
//        loadStatues()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 200
        
        //4.布局header
        
        setUpHeaderView()
        setUpFooterView()
        
        //5.设置提示的Label
        setupTipLabel()
        
        //6.正则表达式
        regularTest()
        
        //7添加点击图片通知
        setUPNatifications()
    }

   
}

 //MARK: --设置UI界面
extension HomeViewController {
   
    private func setupNavigationBar() {
    
        //1.设置左侧的Item
        /*
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: ""), forState: .Normal)
        leftBtn.setImage(UIImage(named: ""), forState: .Highlighted)
        leftBtn.sizeToFit()
        */
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName:"navigationbar_friendattention")
        //2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        //3.设置titleview
        titleBtn.setTitle("archy", forState: .Normal)
        titleBtn.addTarget(self, action: "titilBtnClick:", forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleBtn
        
    }
    
    private func setUpHeaderView() {
    
        //1.创建header
        let header =  MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewStatuses")
        
        //2.设置header的属性
        header.setTitle("下拉刷新", forState: .Idle)
        header.setTitle("释放更新", forState: .Pulling)
        header.setTitle("加载中。。。", forState: .Refreshing)
        
        //3.设置tabelview的header
        tableView.mj_header = header
        
        //4.进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    private func setUpFooterView(){
    
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreStatuses")
    }
    
    
    private func setupTipLabel() {
    
        //1.将tiplabel添加到父控件中
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
        //2.设置tiplabel 的frame 
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.mainScreen().bounds.width, height: 32)
        
        //3.设置tipLabel的属性
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.font = UIFont.systemFontOfSize(14)
        tipLabel.textAlignment = .Center
        tipLabel.hidden = true
        
    }
    
    private func setUPNatifications(){
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showPhotoBrowser:", name: ShowPhotoBrowserNote, object: nil)
    }
}


 //MARK: --事件监听的函数
extension HomeViewController {

    @objc private func titilBtnClick(titleBtn : TitleButton ) {
    
        //1.改变按钮的状态
        titleBtn.selected = !titleBtn.selected
        
        //2.创建弹出的控制器
        let popoverVc = PopoverViewController()
        
        //3.设置控制器的modal样式
        popoverVc.modalPresentationStyle = .Custom
        
        //设置转场代理
        popoverVc.transitioningDelegate = popoviewAnimator
        popoviewAnimator.presentedFrame  = CGRect(x: 100, y: 60, width: 180, height: 250)
        //4.弹出控制器
        
        
        presentViewController(popoverVc, animated: true, completion: nil)
    }
    
    @objc private func showPhotoBrowser(note : NSNotification) {
    
        //1.取出数据
        let indexPath = note.userInfo![ShowPhotoBrowserIndexKey] as! NSIndexPath
        let picURLs = note.userInfo![ShowPhotoBrowserUrlsKey] as! [NSURL]
        
        let object = note.object as! PicCollectionView
        //2.创建控制器
        let photoBrowserVc = PhotoBrowserController(indexPath: indexPath, picUrl: picURLs)
        
        //2.以model形式弹出控制器
        
        //设置modal样式
        photoBrowserVc.modalPresentationStyle = .Custom
        //设置转场的代理
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        
        //设置动画的代理
        photoBrowserAnimator.presentedDelegate = object
        
        photoBrowserAnimator.indexPath = indexPath
        
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        
        //以modal的形式弹出控制器
        presentViewController(photoBrowserVc, animated: true, completion: nil)
    }
}


 //MARK: --请求数据
extension HomeViewController {
    
    //加载最新数据  
    @objc private func loadNewStatuses(){
    
        loadStatues(true)
    }
    
    @objc private func loadMoreStatuses(){
    
        loadStatues(false)
    }
    
    private func loadStatues(isNewdata :Bool){
    
        //1.获取since_id
        var since_id = 0
        var max_id = 0
        if isNewdata {
          since_id = ViewModels.first?.status?.mid ?? 0
        }
        else
        {
            max_id = ViewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        NetworkTools.shareInstance.loadStatuese(since_id,max_id : max_id) { (result, error) -> () in
        
            //1.错误校验
            if error != nil {
              print(error)
                // 停止刷新
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                return
              
              }
            //2.获取可选类型中的数据
            guard let resultArray = result else {
             return
            }
            
            //3.遍历微博对应的字典
            var temViewModel = [StatusViewModel]()
            for statusDict in resultArray {
              let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
//                self.ViewModels.append(viewModel)
                temViewModel.append(viewModel)
             }
           
            //4.将数据放入到成员变量的数组中
            if isNewdata {
                self.ViewModels = temViewModel + self.ViewModels
            }
            else
            {
                self.ViewModels += temViewModel
            }
            
            //4.缓存图片
           self.cacheImages(temViewModel)
        
        }
    }
    
    private func cacheImages(viewModels : [StatusViewModel]){
         //0.创建group
        let group = dispatch_group_create()
        
        //1.缓存图片
        for viewModel in viewModels {
        
            for picUrl in viewModel.picUrls {
            
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(picUrl, options: [], progress: nil, completed: { (_, _, _, _, _) -> Void in
//                    print("下载了一张图：\(picUrl)")
                    dispatch_group_leave(group)
                })
            }
        }
        
        //2.刷新表格
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            
//            print("刷新表格")
            self.tableView.reloadData()
            
            //停止刷新
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            //显示提示label
            self.showTipLable(viewModels.count)
        }
        
        
    }
    // MARK: - 显示提示的label
    private func showTipLable(count : Int) {
        
        //1.设置tiplabel的属性
        tipLabel.hidden = false
        tipLabel.text = count == 0 ? "没有数据" : "\(count)条微博"
        
        //2.执行动画
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.tipLabel.frame.origin.y = 44
            }) { (_) -> Void in
                UIView.animateWithDuration(1.0, delay: 1.5, options: [], animations: { () -> Void in
                    self.tipLabel.frame.origin.y = 10
                    }, completion: { (_) -> Void in
                        self.tipLabel.hidden = true
                })
        }
    }


}



 //MARK: --tableview的数据源方法
extension HomeViewController {

  override    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModels.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //1.创建cell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell") as! HomeViewCell
        
        //2.给cell设置数据
        let viewmodel = ViewModels[indexPath.row]
        cell.viewModel = viewmodel
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        //1.获取模型对象
//        let viewmodel = ViewModels[indexPath.row]
//        print("\(viewmodel.cellHeight)")
//        return viewmodel.cellHeight
//    }
}





extension HomeViewController {

    func regularTest() {
        /*
        练习1:匹配abc
        
        练习2:包含一个a~z,后面必须是0~9 -->[a-z][0-9]或者[a-z]\d
        * [a-z] : a~z
        * [0-9]/\d : 0~9
        
        练习3:必须第一个是字母,第二个是数字 -->^[a-z][0-9]$
        * ^[a-z] : 表示首字母必须是a~z
        * \d{2,10} : 数字有2到10
        * [a-z]$ : 表示必须以a-z的字母结尾
        
        练习4:必须第一个是字母,字母后面跟上4~9个数字
        
        练习5:不能是数字0-9
        
        * [^0-9] : 不能是0~9
        
        
        练习6:QQ匹配:^[1-9]\d{4,11}$
        都是数字
        5~12位
        并且第一位不能是0
        
        
        练习7:手机号码匹配^1[3578]\d{9}$
        1.以13/15/17/18
        2.长度是11
   */
        
        let strString = "13269285976"
        
        //创建表达式规则
        let partern = "^1[3578][0-9]{9}"
        //创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: partern, options: []) else {
        
            return
        }
        //3.匹配字符串中内容
        let results = regex.matchesInString(strString, options: [], range: NSRange(location: 0, length: strString.characters.count))
        
        //4.遍历数组，获取结果
        for result in results {
            print((strString as NSString).substringWithRange(result.range))
            print(result.range)
        }
        
        
        
        let statusText = "@coderwhy:【动物尖叫合辑】#肥猪流#猫头鹰这么尖叫[偷笑]、@M了个J: 老鼠这么尖叫、兔子这么尖叫[吃惊]、@花满楼: 莫名奇#小笼包#妙的笑到最后[好爱哦]！~ http://t.cn/zYBuKZ8/"
        
        //1.创建匹配规则
        let pattern1 = "@.*?:" //匹配出来@codewhy:
        let pattern2 = "#.*?#" //匹配话题
        let pattern3 = "\\[.*?\\]" //匹配表情
        
        let pattern4 = "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?" //URL网址
        //创建正则表达式对象
        guard let regex1 = try? NSRegularExpression(pattern: pattern3, options: []) else
        {
            return
        }
        
        //3.开始匹配
        let resulsts1 = regex1.matchesInString(statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        
        //4.获取结果
        for result1 in resulsts1 {
        
            print((statusText as NSString).substringWithRange(result1.range))
        }
    }
}











