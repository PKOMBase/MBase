//
//  MarkdownEditFactory.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownEditFactory: MarkdownHtmlTag {
    
    static func getMarkdownAttributes(tagRegex: MarkdownRegexCommonEnum) -> [String : AnyObject]{
        
        switch tagRegex {
        case .URL:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .HEADER:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        }
    }
    
    static func getMarkdownAttributes(tagRegex: MarkdownRegexHeaderEnum) -> [String : AnyObject]{
        
        switch tagRegex {
        case .H1:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("# ")];
        case .H2:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("## ")];
        case .H3:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("### ")];
        case .H4:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("#### ")];
        case .H5:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("##### ")];
        case .H6:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("###### ")];

        }
    }
    
    static func getMarkdownAttributes(tagRegex: MarkdownRegexLineEnum) -> [String : AnyObject]{
        
        switch tagRegex {
        case .A1:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .A2:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .IMG1:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .IMG2:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .HR:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        case .STRONG:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.boldFontColor]
        case .EM:
            return [NSFontAttributeName : NSFont.systemFontOfSize(MarkdownConstsManager.defaultFontSize), NSForegroundColorAttributeName : MarkdownConstsManager.boldFontColor];
        case .U:
            return [NSFontAttributeName : NSFont.systemFontOfSize(MarkdownConstsManager.defaultFontSize), NSForegroundColorAttributeName : MarkdownConstsManager.boldFontColor];
        case .TOC:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        }
    }
    
    static func getMarkdownAttributes(tagRegex: MarkdownRegexParagraphEnum) -> [String : AnyObject]{
        switch tagRegex {
        case .CODE1:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        case .CODE2:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        }
    }
    
    static func getMarkdownAttributes(tagRegex: MarkdownRegexListEnum) -> [String : AnyObject]{
        switch tagRegex {
        case .NORMAL:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        case .ORDER:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        case .QUOTE:
            return [NSFontAttributeName : NSFont.boldSystemFontOfSize(MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        }
    }
    
}
