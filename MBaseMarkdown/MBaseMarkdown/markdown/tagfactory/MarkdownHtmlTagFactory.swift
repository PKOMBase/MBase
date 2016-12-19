//
//  MarkdownHtmlTagFactory.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTagFactory: NSObject {
    
    static func getMarkdownHtmlTag(tagRegex: MarkdownRegexCommonEnum, range: NSRange, string: String) -> MarkdownHtmlTagCommon{
        switch tagRegex {
        case .URL:
            return MarkdownHtmlTag4url(range: range, string: string);
        case .HEADER:
            return MarkdownHtmlTagCommon(range: range, string: string);
        }
    }
    
    static func getMarkdownHtmlTag(tagRegex: MarkdownRegexHeaderEnum, range: NSRange, string: String, index: Int) -> MarkdownHtmlTagHeader{
        switch tagRegex {
        case .H1:
            return MarkdownHtmlTag4h1(range: range, string: string, index: index);
        case .H2:
            return MarkdownHtmlTag4h2(range: range, string: string, index: index);
        case .H3:
            return MarkdownHtmlTag4h3(range: range, string: string, index: index);
        case .H4:
            return MarkdownHtmlTag4h4(range: range, string: string, index: index);
        case .H5:
            return MarkdownHtmlTag4h5(range: range, string: string, index: index);
        case .H6:
            return MarkdownHtmlTag4h6(range: range, string: string, index: index);
        }
    }

    static func getMarkdownHtmlTag(tagRegex: MarkdownRegexLineEnum, range: NSRange, string: String) -> MarkdownHtmlTagLine{
        
        switch tagRegex {
            
        case .A1:
            return MarkdownHtmlTag4a1(range: range, string: string);
        case .A2:
            return MarkdownHtmlTag4a2(range: range, string: string);
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
        case .TOC:
            return MarkdownHtmlTag4toc(range: range, string: string);
        }
    }
    
    static func getMarkdownHtmlTag(tagRegex: MarkdownRegexParagraphEnum, range: NSRange, string: String) -> MarkdownHtmlTagParagraph{
        
        switch tagRegex {
        case .CODE1:
            return MarkdownHtmlTag4code1(range: range, string: string);
        case .CODE2:
            return MarkdownHtmlTag4code2(range: range, string: string);
        }
    }
}
