//
//  MarkdownHtmlTag4code2.swift
//  MBase
//
//  Created by sunjie on 16/8/15.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4code2: MarkdownHtmlTagParagraph {

    override init(range: NSRange, string: String){
        super.init(range: range, string: string);
        super.tagName = "code";
        super.codeKey = "`";
        super.markdownTag = ["`"];
    }
    
}
