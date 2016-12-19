//
//  MarkdownHtmlTagLine.swift
//  MBase
//
//  Created by sunjie on 16/8/28.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTagHeader: MarkdownHtmlTag {
    
    override func getParamObejct() -> Dictionary<String, AnyObject>{
        return [self.getId() : self];
    }
    
    override func getHtml(index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        super.tagValue["id"] = self.tagName + "id_" + String(index);
        return super.getHtml(index, object: object);
    }
    
}
