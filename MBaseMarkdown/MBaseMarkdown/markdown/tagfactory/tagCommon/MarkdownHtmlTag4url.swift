//
//  MarkdownHtmlTag4url2.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4url: MarkdownHtmlTagCommon {
    
    override init(range: NSRange, string: String){
        super.init(range: range, string: string);
        super.tagName = "";
        super.markdownTag = [""];
    }
    
    override func getHtml(index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        return "";
    }
    
    override func getParamObejct() -> Dictionary<String, AnyObject>{
        let stringArr = string.componentsSeparatedByString("]:");
        let numString = stringArr[0].stringByReplacingOccurrencesOfString("[", withString: "");
        let hrefString = stringArr[1];
        return [numString: hrefString];
    }
}
