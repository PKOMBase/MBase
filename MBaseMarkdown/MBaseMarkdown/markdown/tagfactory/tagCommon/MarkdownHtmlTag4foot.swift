//
//  MarkdownHtmlTag4url1.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4foot: MarkdownHtmlTagCommon {

    var idString = "";
    
    override init(range: NSRange, string: String){
        super.init(range: range, string: string);
        super.tagName = "li";
        super.markdownTag = ["[","]","^"];
    }
    
    override func getId() -> String{
        return "foot_" + String(self.idString);
    }
    
//    override func getHtml4Prefix() -> String {
//        return super.getHtml4Prefix() + "<li id=\""+self.getId()+"_rev\">";
//    }
//    
    override func getHtml4Suffix() -> String {
        return  "&nbsp;<a href=\"#"+self.getId()+"_rel\" rev=\""+self.getId()+"\">&#8617;</a></li>" + super.getHtml4Suffix();
    }
    
    override func getParamObejct(index: Int) -> Dictionary<String, AnyObject>{
        let stringArr = string.components(separatedBy: "]:");
        self.idString = stringArr[0].replacingOccurrences(of: "[^", with: "");
        super.index = index;
        super.tagValue["id"] = self.getId()+"_rev";
        super.string = stringArr[1].replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "");
        return [self.getId(): self];
    }
    
}
