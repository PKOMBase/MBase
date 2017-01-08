//
//  MarkdownHtmlTag4url1.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4normal: MarkdownHtmlTagList {

    override func getHtml(_ index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        if string == ""{
            return super.getHtml(index, object: object);
        }
        var result = self.string;
        result = NSString(string: result).replacingOccurrences(of: "<p>\\* ", with: "<ul><li>", options: [.regularExpression], range: NSMakeRange(0,  result.characters.count));
        result = NSString(string: result).replacingOccurrences(of: "<br/>\\* ", with: "</li><li>", options: [.regularExpression],range: NSMakeRange(0,  result.characters.count));
        result = NSString(string: result).replacingOccurrences(of: "</p>", with: "</li></ul>", options: [.regularExpression],range: NSMakeRange(0,  result.characters.count));
        return result;
    }
    
}
