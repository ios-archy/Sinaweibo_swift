//
//  PicPickerViewCell.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/11/17.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {

    // //MARK: --控制的属性
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var iamgeView: UIImageView!
    @IBOutlet weak var removePhotoBtn: UIButton!
    
    
    
    
    
     //MARK: --定义属性
    var image : UIImage? {
        didSet {
            if image != nil {
                iamgeView.image = image
//                addPhotoBtn.setBackgroundImage(image, forState: .Normal)
                addPhotoBtn.userInteractionEnabled = false
                removePhotoBtn.hidden = true
            }else
            {
                iamgeView.image = nil
//            addPhotoBtn.setBackgroundImage(UIImage(named: ""), forState: .Normal)
                addPhotoBtn.userInteractionEnabled = true
                removePhotoBtn.hidden = false
            }
        }
    }
    //移除
    @IBAction func removePhotoClick(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerRemovePhotoNote, object: iamgeView.image)
    }
     //MARK: --添加
    @IBAction func addPhotoClick() {
          NSNotificationCenter.defaultCenter().postNotificationName(PicPickerAddPhotoNote, object: nil)
        
    }

}
