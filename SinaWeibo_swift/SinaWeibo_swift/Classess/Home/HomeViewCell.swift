//
//  HomeViewCell.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/26.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit


private let edgeMargin : CGFloat = 15

class HomeViewCell: UITableViewCell {
    
    
     //MARK: --控件属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
     //MARK: --约束属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    
    
     //MARK: --自定义属性
    
    var viewModel : StatusViewModel? {
    
        didSet {
        
            //1.nil值校验
            guard let viewModel = viewModel else {
            
                return
            }
            
            //2.设置头像
            iconView.sd_setImageWithURL(viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            
            //3.设置认证的图标
            verifiedView.image = viewModel.verifiedImage
            
            //4.昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            
            //5.会员图标
            vipView.image = viewModel.vipImage
            
            //6.设置时间的lable
            timeLabel.text = viewModel.createAtText
            
            //7.设置来源
            contentLabel.text = viewModel.status?.text
            
            //8.设置昵称的颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.blackColor() : UIColor.orangeColor()
        }
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
    }
    
}
