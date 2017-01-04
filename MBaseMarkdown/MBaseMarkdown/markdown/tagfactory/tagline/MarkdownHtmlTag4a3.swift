//
//  MarkdownHtmlTag4url3.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4a3: MarkdownHtmlTagLine {
    
    override init(range: NSRange, string: String){
        super.init(range: range, string: string);
        super.tagName = "a";
        super.markdownTag = ["<",">"];
    }
    
    override func getHtml(_ index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        if string == ""{
            return super.getHtml(index, object: object);
        }
        var result = string;
        super.tagValue["href"] = string.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "");
        return super.getHtml(index, object: object);
    }
}
