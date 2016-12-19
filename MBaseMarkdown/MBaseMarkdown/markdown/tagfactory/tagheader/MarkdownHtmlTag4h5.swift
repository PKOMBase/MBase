//
//  MarkdownHtmlTag4h5.swift
//  MBase
//
//  Created by sunjie on 16/8/12.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4h5: MarkdownHtmlTagHeader {

    override init(range: NSRange, string: String, index: Int){
        super.init(range: range, string: string, index: index);
        super.tagName = "h5";
        super.markdownTag = ["##### "];
    }

}
