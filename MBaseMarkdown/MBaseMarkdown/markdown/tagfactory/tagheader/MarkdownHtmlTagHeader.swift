//
//  MarkdownHtmlTagLine.swift
//  MBase
//
//  Created by sunjie on 16/8/28.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTagHeader: MarkdownHtmlTag {
    
    var level = 0;

    override func getParamObejct(index: Int) -> Dictionary<String, AnyObject>{
        return [self.getId() : self];
    }
    
    override func getString() -> String{
        var str = self.string;
        for tag in self.markdownTag {
            str = (str as! NSString).replacingOccurrences(of: tag, with: "", options: .regularExpression, range: NSMakeRange(0, (str as! NSString).length));
        }
        return str;
    }
    
    override func getHtml(_ index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        super.tagValue["id"] = self.tagName + "id_" + String(index);
        return super.getHtml(index, object: object);
    }
    
}
