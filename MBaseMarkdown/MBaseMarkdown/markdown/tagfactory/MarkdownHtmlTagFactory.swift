//
//  MarkdownHtmlTagFactory.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTagFactory: NSObject {
    
    static func getMarkdownHtmlTag(_ tagRegex: MarkdownRegexCommonEnum, range: NSRange, string: String) -> MarkdownHtmlTagCommon{
        switch tagRegex {
        case .URL:
            return MarkdownHtmlTag4url(range: range, string: string);
        case .HEADER:
            return MarkdownHtmlTagCommon(range: range, string: string);
        }
    }
    
    static func getMarkdownHtmlTag(_ tagRegex: MarkdownRegexHeaderEnum, range: NSRange, string: String, index: Int) -> MarkdownHtmlTagHeader{
        let level = (string as! NSString).range(of: "(\\#{1,6})", options: .regularExpression, range: NSMakeRange(0, (string as! NSString).length), locale: nil).length;
        switch level {
        case 1:
            return MarkdownHtmlTag4h1(range: range, string: string, index: index);
        case 2:
            return MarkdownHtmlTag4h2(range: range, string: string, index: index);
        case 3:
            return MarkdownHtmlTag4h3(range: range, string: string, index: index);
        case 4:
            return MarkdownHtmlTag4h4(range: range, string: string, index: index);
        case 5:
            return MarkdownHtmlTag4h5(range: range, string: string, index: index);
        case 6:
            return MarkdownHtmlTag4h6(range: range, string: string, index: index);
        default:
            return MarkdownHtmlTag4h6(range: range, string: string, index: index);
        }
    }

    static func getMarkdownHtmlTag(_ tagRegex: MarkdownRegexLineEnum, range: NSRange, string: String) -> MarkdownHtmlTagLine{
        switch tagRegex {
        case .A1:
            return MarkdownHtmlTag4a1(range: range, string: string);
        case .A2:
            return MarkdownHtmlTag4a2(range: range, string: string);
        case .A3:
            return MarkdownHtmlTag4a3(range: range, string: string);
        case .A4:
            return MarkdownHtmlTag4a4(range: range, string: string);
        case .IMG1:
            return MarkdownHtmlTag4img1(range: range, string: string);
        case .IMG2:
            return MarkdownHtmlTag4img2(range: range, string: string);
        case .HR:
            return MarkdownHtmlTag4hr(range: range, string: string);
        case .STRONG:
            return MarkdownHtmlTag4strong(range: range, string: string);
        case .EM:
            return MarkdownHtmlTag4em(range: range, string: string);
        case .U:
            return MarkdownHtmlTag4u(range: range, string: string);
        case .DEL:
            return MarkdownHtmlTag4del(range: range, string: string);
        case .TOC:
            return MarkdownHtmlTag4toc(range: range, string: string);
        }
    }
    
    static func getMarkdownHtmlTag(_ tagRegex: MarkdownRegexParagraphEnum, range: NSRange, string: String) -> MarkdownHtmlTagParagraph{
        
        switch tagRegex {
        case .CODE1:
            return MarkdownHtmlTag4code1(range: range, string: string);
        case .CODE2:
            return MarkdownHtmlTag4code2(range: range, string: string);
        }
    }
}
