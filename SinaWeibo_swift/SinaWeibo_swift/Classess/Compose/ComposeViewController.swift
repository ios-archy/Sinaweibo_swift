//
//  ComposeViewController.swift
//  SinaWeibo_swift
//
//  Created by yuqi on 16/11/5.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit
import SVProgressHUD
class ComposeViewController: UIViewController {

    // MARK:-懒加载属性
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    private lazy var images : [UIImage] = [UIImage]()
    
    private lazy var emoticonVc : EmotionController  = EmotionController{[weak self] (emoticon) -> () in
        self?.textView.insertEmoticon(emoticon)
        self?.textViewDidChange(self!.textView)
    }
    
    //控件属性
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var pickerView: PicPickerCollectionView!
    
    
    //约束属性
    @IBOutlet weak var picPicerViewHCons: NSLayoutConstraint!
    @IBOutlet weak var ToolBarBottomCons: NSLayoutConstraint!
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //设置导航栏
        setupNavigationBar()
        
        //监听通知
       setupNotification()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    deinit{
       NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension ComposeViewController {

    private func setupNavigationBar (){
    
    //1.设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: "closeItemClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: "sendItemClick")
        navigationItem.rightBarButtonItem?.enabled = false
        
        //2。设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    private func setupNotification(){
    
        //监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        //监听添加照片的按钮的点击
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addPhotoClick", name: PicPickerAddPhotoNote, object: nil)
        
        //监听删除照片的按钮的点击
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removePhotoClick:", name: PicPickerRemovePhotoNote, object: nil)
    }
}

extension ComposeViewController {

    @objc private func closeItemClick(){
    dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func sendItemClick(){
        
        
    print("sendItemClick")
        
        textView.resignFirstResponder()
        
        //1.获取发布微博的微博正文
        let statusText = textView.getEmoticonString()
        
        //2.定义回调的闭包
        let finishedCallBack = { (isSuccess : Bool) -> () in
            
            if !isSuccess {
             SVProgressHUD.showErrorWithStatus("发送微博失败")
                return
            }
            SVProgressHUD.showSuccessWithStatus("发送微博成功")
            self.dismissViewControllerAnimated(true, completion: nil)
            
        
        }
        
        //3.获取用户选中的图片
        if let image = images.first {
        NetworkTools.shareInstance.sendStatus(statusText, image: image, isSuccess: finishedCallBack)
        }
        else
        {
            NetworkTools.shareInstance.sendStatus(statusText, isSuccess: finishedCallBack)
        }
    }
    
    @objc private func keyboardWillChangeFrame(note : NSNotification)
    {
        
        //1.获取动画执行时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        
        //2.获取键盘最终Y值
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let y = endFrame.origin.y
        
        //3.计算工具栏距离底部的间距
        let margin = UIScreen.mainScreen().bounds.height - y
        
        //4.执行动画
        ToolBarBottomCons.constant = margin
        UIView.animateWithDuration(duration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPickerBtnClick(sender: AnyObject) {
        
        //退出键盘
        textView.resignFirstResponder()
        
        //执行动画
        picPicerViewHCons.constant = UIScreen.mainScreen().bounds.height * 0.65
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    //表情按钮点击
    @IBAction func emotionBtnClick(sender: AnyObject) {
        
        //1.退出键盘
        textView.resignFirstResponder()
        
        //2.切换键盘
        textView.inputView = textView.inputView != nil ? nil : emoticonVc.view
        
        //3.弹出键盘
        textView.becomeFirstResponder()
    }
    
    
}

 //MARK: --添加照片和删除照片的时间
extension ComposeViewController {

    @objc private func addPhotoClick (){
    //1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
        {
            return
        }
        //2.创建照片选择控制器
        let ipc = UIImagePickerController()
        
        //3.设置找片源
        ipc.sourceType = .PhotoLibrary
        
        //4.设置代理
        ipc.delegate = self
        
        //弹出选择照片的控制器
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    
    @objc private func removePhotoClick(note :NSNotification)
    {
        //1.获取image对象
        guard let image = note.object as? UIImage else {
        return
        }
        
        //2.获取image对象所在下标值
        guard let index = images.indexOf(image) else
        {
            return
        }
        
        //3。将图片从数组中删除
        images.removeAtIndex(index)
        
        //4.重写赋值collectionView新的数组
        pickerView.images = images;
    }
}

 //MARK: --UIImagePickerController的代理方法
extension ComposeViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //1.获取选中的图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //2.将选中的图片添加到数组中
        images.append(image)
        
        //3.将数组赋值为collectionview，让collectionView自己去展示数据
        pickerView.images = images
        //4.退出选中照片控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
   
}



//MARK :-UItextview的代理方法
extension ComposeViewController : UITextViewDelegate {

    func textViewDidChange(textView: UITextView) {
        self.textView.placeHoderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}