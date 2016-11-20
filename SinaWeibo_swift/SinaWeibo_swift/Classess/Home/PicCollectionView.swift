//
//  PicCollectionView.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/28.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

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
//        let userInfo  = 
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
