//
//  MarkdownHtmlTag4url1.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4footrel: MarkdownHtmlTagLine {
    
    var idString = "";
    
    override init(range: NSRange, string: String){
        super.init(range: range, string: string);
        super.tagName = "sup";
        super.markdownTag = ["[","]","^"];
    }
    
    override func getId() -> String{
        return "foot_" + String(self.idString);
    }
    
    override func getHtml4Prefix() -> String {
        return super.getHtml4Prefix() + "<a href=\"#"+self.getId()+"_rev\" rel=\""+self.getId()+"\">";
    }
    
    override func getHtml4Suffix() -> String {
        return  "</a>" + super.getHtml4Suffix();
    }
    
    override func getHtml(_ index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        if string == ""{
            return super.getHtml(index, object: object);
        }
        self.idString = string.replacingOccurrences(of: "[^", with: "").replacingOccurrences(of: "]", with: "");
        var myIndex = index;
        if object[MarkdownRegexCommonEnum.FOOT] != nil{
            for footNote in object[MarkdownRegexCommonEnum.FOOT]! {
                for idString in footNote.keys{
                    if idString == self.getId(){
                        myIndex = (footNote[idString] as! MarkdownHtmlTagCommon).index;
                    }
                }
            }
        }
        super.string = String(myIndex);
        super.tagValue["id"] = self.getId()+"_rel";
        return super.getHtml(index, object: object);
    }
}
