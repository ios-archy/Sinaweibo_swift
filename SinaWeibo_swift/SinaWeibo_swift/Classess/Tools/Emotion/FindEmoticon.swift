//
//  FindEmoticon.swift
//  Emotion
//
//  Created by yuqi on 16/11/20.
//  Copyright © 2016年 archy. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    // MARK:- 实际单例对象
    static let shareInstance : FindEmoticon = FindEmoticon ()
    
    // MARK:- 表情素材
    private lazy  var manager : EmoticonManager = EmoticonManager()
    
    //查找属性字符串的方法
    func findAttrisString(statusText : String ,font : UIFont) -> NSMutableAttributedString? {
    
        //1.创建匹配规则
        let patter = "\\[.*?\\]" //匹配表情
        //2.创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: patter, options: [])
            else
        {
          return nil
        }
        
        //3.开始匹配
        let results = regex.matchesInString(statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        
        //4.获取结果
        let attrMstr = NSMutableAttributedString(string: statusText)
        for var i = results.count - 1; i >= 0; i-- {
        //4.0获取结果
            let result = results[i]
            //4.1获取chs
            let chs = (statusText as NSString).substringWithRange(result.range)
            
            //4.2根据chs,获取图片路径
            guard let pngPath = findPngPath(chs) else
            {
                return nil
            }
            
            //4.3创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            
            //4.将属性字符串替换到来源的文字位置
            attrMstr.replaceCharactersInRange(result.range, withAttributedString: attrImageStr)
            
        }
        //返回结果
        return attrMstr
    }
    
    private func findPngPath(chs : String) -> String? {
    
        for package in manager.packages {
            for emoticon in package.emoticons {
            if emoticon.chs == chs{
               return emoticon.pngPath
              }
            }
        }
        return nil
    }
}
