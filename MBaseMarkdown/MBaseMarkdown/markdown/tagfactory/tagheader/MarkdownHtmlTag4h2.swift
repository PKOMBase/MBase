//
//  MarkdownHtmlTag4h2.swift
//  MBase
//
//  Created by sunjie on 16/8/11.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4h2: MarkdownHtmlTagHeader {

    override init(range: NSRange, string: String, index: Int){
        super.init(range: range, string: string, index: index);
        super.tagName = "h2";
        super.markdownTag = ["## "];
    }

}
