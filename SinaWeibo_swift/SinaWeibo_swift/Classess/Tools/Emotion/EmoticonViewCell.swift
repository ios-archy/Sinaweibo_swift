//
//  EmoticonViewCell.swift
//  Emotion
//
//  Created by archy on 16/11/18.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    
     //MARK: --懒加载
    private lazy var emoticonBtn : UIButton = UIButton()
    
     //MARK: --定义的属性
    var emoticon : Emoticon? {
    
        didSet {
        
            guard let emoticon = emoticon else {
            return
            }
            
            //1.设置emoticonBtn的内容
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), forState: .Normal)
            emoticonBtn.setTitle(emoticon.emojiCode, forState: .Normal)
            
            //2.设置删除按钮
            if emoticon.isRemove {
            
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
            }
        }
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension EmoticonViewCell {

    private func setupUI(){
    
        //1.添加子控件
        contentView.addSubview(emoticonBtn)
        
        //2.设置btn的frame
        emoticonBtn.frame = contentView.bounds
        
        //3.设置btn属性
        emoticonBtn.userInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFontOfSize(32)
        
    }
}