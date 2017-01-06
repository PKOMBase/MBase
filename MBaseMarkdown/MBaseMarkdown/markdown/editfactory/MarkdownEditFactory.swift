//
//  MarkdownEditFactory.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownEditFactory: MarkdownHtmlTag {
    
    static func getMarkdownAttributes(_ tagRegex: MarkdownRegexCommonEnum) -> [String : AnyObject]{
        
        switch tagRegex {
        case .URL:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .HEADER:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        }
    }
    
    static func getMarkdownAttributes(_ tagRegex: MarkdownRegexHeaderEnum) -> [String : AnyObject]{
        
        switch tagRegex {
        case .H1:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("# ")];
        case .H2:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("## ")];
        case .H3:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("### ")];
        case .H4:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("#### ")];
        case .H5:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("##### ")];
        case .H6:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("###### ")];
        case .H:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.headerFontColor, NSParagraphStyleAttributeName: MarkdownConstsManager.getHeaderParagraphStyle("###### ")];
        }
    }
    
    static func getMarkdownAttributes(_ tagRegex: MarkdownRegexLineEnum) -> [String : AnyObject]{
        
        switch tagRegex {
        case .A1:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .A2:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .A3:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .A4:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .IMG1:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .IMG2:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        case .HR:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        case .STRONG:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.boldFontColor]
        case .EM:
            return [NSFontAttributeName : NSFont.systemFont(ofSize: MarkdownConstsManager.defaultFontSize), NSForegroundColorAttributeName : MarkdownConstsManager.boldFontColor];
        case .U:
            return [NSFontAttributeName : NSFont.systemFont(ofSize: MarkdownConstsManager.defaultFontSize), NSForegroundColorAttributeName : MarkdownConstsManager.boldFontColor];
        case .DEL:
            return [NSFontAttributeName : NSFont.systemFont(ofSize: MarkdownConstsManager.defaultFontSize), NSForegroundColorAttributeName : MarkdownConstsManager.boldFontColor];
        case .TOC:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.linkFontColor];
        }
    }
    
    static func getMarkdownAttributes(_ tagRegex: MarkdownRegexParagraphEnum) -> [String : AnyObject]{
        switch tagRegex {
        case .CODE1:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        case .CODE2:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        }
    }
    
    static func getMarkdownAttributes(_ tagRegex: MarkdownRegexListEnum) -> [String : AnyObject]{
        switch tagRegex {
        case .NORMAL:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        case .ORDER:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        case .QUOTE:
            return [NSFontAttributeName : NSFont.boldSystemFont(ofSize: MarkdownConstsManager.defaultFontSize),NSForegroundColorAttributeName : MarkdownConstsManager.codeFontColor];
        }
    }
    
}
