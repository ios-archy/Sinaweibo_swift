//
//  PicPickerCollectionView.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/11/17.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"
private let edgeMargin : CGFloat = 15

class PicPickerCollectionView :UICollectionView {
    
     //MARK: --定义属性
    var images : [UIImage] = [UIImage](){
        didSet {
        reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置collectionView的layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemWH = (UIScreen.mainScreen().bounds.width - 4 * edgeMargin) / 3
        
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        
        //设置collectionView的属性
        registerNib(UINib(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        
        dataSource = self
        
        //设置collectionView的内边距
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: edgeMargin, right: edgeMargin)
    }
}

extension PicPickerCollectionView : UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(picPickerCell, forIndexPath: indexPath) as! PicPickerViewCell
        
        //2给cell设置数据
//        cell.backgroundColor = UIColor.redColor()
        cell.image = indexPath.item <= images.count-1 ? images[indexPath.item] : nil
        
        return cell
    }
}