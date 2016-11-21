//
//  PicCollectionView.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/28.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit
import SDWebImage
class PicCollectionView: UICollectionView {
    
    //MARK: --定义属性
    var picURLs : [NSURL] = [NSURL]() {
        
        didSet {
            self.reloadData()
        }
    }
    // //MARK: --系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }

}


 //MARK: --collectionView的数据源方法
extension PicCollectionView :UICollectionViewDataSource ,UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1.获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("picCell", forIndexPath: indexPath) as! PicCollectionViewCell
        
        //2.给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //1获取通知所需要的参数
        let userInfo  = [ShowPhotoBrowserIndexKey : indexPath, ShowPhotoBrowserUrlsKey : picURLs]
        
        //2.发出通知
        NSNotificationCenter.defaultCenter().postNotificationName(ShowPhotoBrowserNote, object: self , userInfo: userInfo)
        
    }
    
}

extension PicCollectionView : AnimatorPresentedDelegate {

    func startRect(indexPath: NSIndexPath) -> CGRect {
        //1.获取cell
        let cell = self.cellForItemAtIndexPath(indexPath)!
        
        //2.获取cell的frame
        let statrtFrame = self.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        
        return statrtFrame
    }
    
    func endRect(indexPath: NSIndexPath) -> CGRect {
        //1.获取该位置的image对象
        let picUlr = picURLs[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picUlr.absoluteString)
        //2.计算结果后的frame
        let w = UIScreen.mainScreen().bounds.width
        let h = w / image.size.width * image.size.height
        var y : CGFloat = 0
        if h > UIScreen.mainScreen().bounds.height {
           y = 0
        }
        else
        {
         y = (UIScreen.mainScreen().bounds.height - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        //1.创建UIImageView对象
        let imageView = UIImageView()
        
        //2.获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
        
        //3.设置imageView的属性
        imageView.image = image
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}



class PicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    
     //MARK: --定义模型属性
    var picURL : NSURL? {
        didSet {
            guard let picURL = picURL else {
            return
            }
            
            iconView.sd_setImageWithURL(picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
}
