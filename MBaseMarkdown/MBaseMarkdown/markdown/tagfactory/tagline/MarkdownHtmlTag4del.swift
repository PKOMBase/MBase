//
//  MarkdownHtmlTag4u.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4del: MarkdownHtmlTagLine {

    override init(range: NSRange, string: String){
        super.init(range: range, string: string);
        super.tagName = "del";
        super.markdownTag = ["~~"];
    }
    
}
