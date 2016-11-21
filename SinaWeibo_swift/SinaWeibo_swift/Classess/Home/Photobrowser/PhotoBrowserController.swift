//
//  PhotoBrowserController.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/11/21.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
private let PhotoBrowserCell = "PhotoBrowserCell"

class PhotoBrowserController: UIViewController {

    
    //MARK: -- 定义属性
    var indexPath : NSIndexPath
    var picUrls : [NSURL]
    
    //MARK: -- 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero ,collectionViewLayout:PhotoBrowserCollectionViewLayout() )
    
    private lazy var closeBtn :UIButton = UIButton (bgColor: UIColor.darkGrayColor(), fontsize: 14, titel: "关闭")
    private lazy var savaBtn : UIButton = UIButton (bgColor: UIColor.darkGrayColor(), fontsize: 14, titel: "保存")
    
    //MARK: --自定义构造函数
    init(indexPath : NSIndexPath , picUrl : [NSURL])
    {
        self.indexPath = indexPath
        self.picUrls = picUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
         fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       //设置UI界面
        setupUI()
        
        //设置滚动到对应的图片
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }


}

extension PhotoBrowserController {

    private func setupUI() {
    
        //1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(savaBtn)
        
        //2.设置frame
        collectionView.frame = view.bounds
        closeBtn.frame = CGRect(x: 20, y: (view.bounds.height-20-32), width: 90, height: 32)
        savaBtn.frame = CGRect(x: view.bounds.width-110, y: (view.bounds.height-20-32), width: 90, height: 32)
//        closeBtn.snp_makeConstraints { (make) -> Void in
//            make.left.equalTo(20)
//            make.bottom.equalTo(-20)
//            make.size.equalTo(CGSize(width: 90, height: 32))
//        }
//        savaBtn.snp_makeConstraints { (make) -> Void in
//            make.right.equalTo(-20)
//            make.bottom.equalTo(closeBtn.snp_bottom)
//            make.size.equalTo(closeBtn.snp_size)
//        }
        

        
        //3.设置collectionView的属性
        collectionView.registerClass(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //4.监听两个按钮的点击
        closeBtn.addTarget(self, action: "closeBtnClick", forControlEvents: .TouchUpInside)
        savaBtn.addTarget(self, action: "saveBtnClick", forControlEvents: .TouchUpInside)
    }
}

 //MARK: --事件监听函数
extension PhotoBrowserController {

    @objc private func closeBtnClick (){
    dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func saveBtnClick() {
//    print("saveBtnClick")
        //1.获取当前正在显示的image
        let cell = collectionView.visibleCells().first as! PhotoBrowserViewCell
        
        guard let image = cell.imageView.image else {
        
            return
        }
        
        //2.将iamge对象保存相册
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishedSavingWithError:contextInfo:", nil)
    }
    
    @objc private func image(image : UIImage ,didFinishedSavingWithError error : NSError?, contextInfo : AnyObject) {
    
        var showInfo = ""
        if error != nil {
        showInfo = "保存失败"
        }
        else {
        showInfo = "保存成功"
        }
        SVProgressHUD.showInfoWithStatus(showInfo)
    }
}


 //MARK: --实现collectionView的数据源方法
extension PhotoBrowserController : UICollectionViewDataSource ,UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //1.创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCell, forIndexPath: indexPath) as! PhotoBrowserViewCell
        
        //2.给cell设置数据
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.redColor() : UIColor.orangeColor()
         cell.picURL = picUrls[indexPath.item]
         cell.delegate = self
        
        return cell
    }
}

extension PhotoBrowserController : PhotoBrowserViewCellDelegate {

    func imageViewClick() {
        closeBtnClick()
    }
}


class PhotoBrowserCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepareLayout() {
        
        super.prepareLayout()
        
        //1.设置itemSize 
        itemSize = collectionView!.frame.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection  = .Horizontal
        
        //2.设置collectionView的属性
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}