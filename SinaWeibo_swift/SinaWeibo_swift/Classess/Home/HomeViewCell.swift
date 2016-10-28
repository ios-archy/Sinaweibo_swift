//
//  HomeViewCell.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/26.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit


private let edgeMargin : CGFloat = 15

private let itemMargin : CGFloat = 10
class HomeViewCell: UITableViewCell {
    
    
     //MARK: --控件属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picView: PicCollectionView!
    
     //MARK: --约束属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    
    
     //MARK: --自定义属性
    @IBOutlet weak var picViewHcons: NSLayoutConstraint!
    @IBOutlet weak var picViewCons: NSLayoutConstraint!
    
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
            
            //9.计算picviewSize 的宽度和高度约束
            let picViewSize  = calculatePicViewSize(viewModel.picUrls.count)
            picViewCons.constant  = picViewSize.width
            picViewHcons.constant = picViewSize.height
            
            //10.将picURL数据传递给picview
            picView.picURLs = viewModel.picUrls
        }
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        
        //取出picView对应的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let imageViewWH = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
    }
    
}


 //MARK: --picView高度计算
extension HomeViewCell
{
    private func calculatePicViewSize(count : Int) -> CGSize {
    
        //1.没有配图
        if count == 0  {
        return CGSizeZero
        }
        
        //2.计算出来imageViewWH
        let imageViewWH = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
        //3.四张图
        if count == 4 {
        let picViewWH = imageViewWH * 2 + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        //4.其他张配图
        //4.1计算行数
        let rows = CGFloat((count - 1 ) / 3 + 1)
        
        //4.2计算picview的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        
        //4.3计算picview的宽度
        let picViewW = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
    
}
