//
//  MarkdownHtmlTag4separator.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4hr: MarkdownHtmlTagLine {
    
    override init(range: NSRange, string: String){
        super.init(range: range, string: string);
        super.tagName = "hr";
        super.markdownTag = ["- - -"];
    }
    
    override func getHtml(index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        return self.tagL + self.tagName + self.tagEnd + self.tagR;
    }
}
