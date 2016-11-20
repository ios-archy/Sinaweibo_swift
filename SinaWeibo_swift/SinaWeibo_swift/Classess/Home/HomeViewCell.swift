//
//  HomeViewCell.swift
//  SinaWeibo_swift
//
//  Created by archy on 16/10/26.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit
import SDWebImage
import HYLabel
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
    @IBOutlet weak var contentLabel: HYLabel!
    @IBOutlet weak var picView: PicCollectionView!
    
    
    
    
    
    
    
     //MARK: --约束属性
    @IBOutlet weak var bottomToolView: UIView!
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    
    
     //MARK: --自定义属性
    @IBOutlet weak var retweetedContentLabel: HYLabel!
    
    @IBOutlet weak var picViewHcons: NSLayoutConstraint!
    @IBOutlet weak var retweetedBgView: UIView!
    @IBOutlet weak var picViewCons: NSLayoutConstraint!
     @IBOutlet   weak var picViewBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var retweetedContentLabelTopCons: NSLayoutConstraint!
    
    
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
            
            //7.设置正文
            contentLabel.attributedText = FindEmoticon.shareInstance.findAttrisString( (viewModel.status?.text)!, font: contentLabel.font)
            
            //设置来源
            sourceLabel.text = viewModel.soureceText
            
            //8.设置昵称的颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.blackColor() : UIColor.orangeColor()
            
            //9.计算picviewSize 的宽度和高度约束
            let picViewSize  = calculatePicViewSize(viewModel.picUrls.count)
            picViewCons.constant  = picViewSize.width
            picViewHcons.constant = picViewSize.height
            
            //10.将picURL数据传递给picview
            picView.picURLs = viewModel.picUrls
            
            //11。设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name, retweetedText = viewModel.status?.retweeted_status?.text {
                  retweetedContentLabel.text = "@" + "\(screenName):" + retweetedText
                    
                    //设置转发正文距离顶部的约束
                    retweetedContentLabelTopCons.constant = 15
                }
                
                //设置背景颜色显示
                retweetedBgView.hidden = false
            }
            else {
                retweetedContentLabel.text = nil
                
                //2.设置背景显示
                retweetedBgView.hidden = true
                
                //3.设置转发正文距离顶部的约束
                retweetedContentLabelTopCons.constant = 0;
            }
            
            //12.计算cell的高度
            if viewModel.cellHeight == 0 {
            //12.1强制布局
                layoutIfNeeded()
                
                //12.2获取底部工具栏的最大Y值
                viewModel.cellHeight = CGRectGetMaxY(bottomToolView.frame)
            }
        }
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        
        //设置HYLabel的内容
        contentLabel.matchTextColor = UIColor.purpleColor()
        retweetedContentLabel.matchTextColor = UIColor.purpleColor()
        
        //监听HYLabel内容的点击
        //监听@谁谁的点击
        contentLabel.userTapHandler = {(label , user, range) in
        
            print(user)
            print(range)
            
        }
        
        //监听链接的点击
        contentLabel.linkTapHandler = {(label , link ,range) in
        
            print(link)
            print(range)
        }
        
        //监听话题的点击
        contentLabel.topicTapHandler = { (label , toppic ,range ) in
        
            print(toppic)
            print(range)
        }
        
        
//        //取出picView对应的layout
//        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
//        
//        let imageViewWH = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
//        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
    }
    
}


 //MARK: --picView高度计算
extension HomeViewCell
{
    private func calculatePicViewSize(count : Int) -> CGSize {
    
        //1.没有配图
        if count == 0  {
            picViewBottomCons.constant = 0
        return CGSizeZero
        }
        
        picViewBottomCons.constant  = 10
        //2. 取出picView对应的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //3.单张配图
        if count == 1 {
        
            //1取出图片
            let urlString = viewModel?.picUrls.last?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlString)
            
            //2.设置一张图片是layout的itemsize
            layout.itemSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
            
            return CGSize(width: image.size.width * 2, height: image.size.height * 2)
        }
        //2.计算出来imageViewWH
        let imageViewWH = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
        
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
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
