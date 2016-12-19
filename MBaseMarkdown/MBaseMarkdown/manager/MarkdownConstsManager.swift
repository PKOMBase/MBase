//
//  SingletonClass.swift
//  MBase
//
//  Created by sunjie on 16/8/9.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

public class MarkdownConstsManager {
    
   public static let docEditDisableBgColor = NSColor(deviceRed: (244+1)/256, green: (244+1)/256, blue: (244+1)/256, alpha: 1);
    
   public static let docEditEnableBgColor = NSColor(deviceRed: (249+1)/256, green: (246+1)/256, blue: (236+1)/256, alpha: 1);
    
   public static let defaultFontSize: CGFloat = 15;
    
   public static let defaultFontColor = NSColor(calibratedRed: (71+1)/256, green: (97+1)/256, blue: (98+1)/256, alpha: 1);
    
   public static let boldFontColor = NSColor(calibratedRed: (200+1)/256, green: (28+1)/256, blue: (36+1)/256, alpha: 1);
    
   public static let headerFontColor = NSColor(calibratedRed: (54+1)/256, green: (156+1)/256, blue: (37+1)/256, alpha: 1);
    
   public static let linkFontColor = NSColor(calibratedRed: (150+1)/256, green: (156+1)/256, blue: (37+1)/256, alpha: 1);
    
   public static let codeFontColor = NSColor(calibratedRed: (200+1)/256, green: (156+1)/256, blue: (37+1)/256, alpha: 1);
    
   private static var markdownHelpString: String?;
    
   private static var defaultParagraphStyle: NSMutableParagraphStyle?;
    
   private static var headerParagraphStyle: NSMutableParagraphStyle?;
    
   public static func getMarkdownHelp() -> String{
        if markdownHelpString != nil{
            return markdownHelpString!;
        }
        let file = NSBundle.mainBundle().pathForResource("markdownHelp", ofType: "strings")
        markdownHelpString = try! String(contentsOfFile: file!)
        return markdownHelpString!;
    }
    
   public static func getDefaultParagraphStyle() -> NSMutableParagraphStyle{
        if defaultParagraphStyle != nil{
            return defaultParagraphStyle!;
        }
        defaultParagraphStyle = NSMutableParagraphStyle();
        //行间距
        defaultParagraphStyle!.lineSpacing = 3;
        //段落间距
        defaultParagraphStyle!.paragraphSpacing = 3;
        //对齐方式
        defaultParagraphStyle!.alignment = NSTextAlignment.Left;
        //指定段落开始的缩进像素
        defaultParagraphStyle!.firstLineHeadIndent = 50;
        //调整全部文字的缩进像素
        defaultParagraphStyle!.headIndent = 50;
        return defaultParagraphStyle!;
    }
    
   public static func getHeaderParagraphStyle(headerString: String) -> NSMutableParagraphStyle{
        headerParagraphStyle = NSMutableParagraphStyle();
        //行间距
        headerParagraphStyle!.lineSpacing = 3;
        //段落间距
        headerParagraphStyle!.paragraphSpacing = 3;
        //对齐方式
        headerParagraphStyle!.alignment = NSTextAlignment.Left;
        
        let size = headerString.sizeWithAttributes([NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize)]);
        //指定段落开始的缩进像素
        headerParagraphStyle!.firstLineHeadIndent = 50 - size.width;
        //调整全部文字的缩进像素
        headerParagraphStyle!.headIndent = 50;
        return headerParagraphStyle!;
    }
    
}
