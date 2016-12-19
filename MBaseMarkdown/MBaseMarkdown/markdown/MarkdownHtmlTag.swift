//
//  MarkdownHtmlTag.swift
//  MBase
//
//  Created by sunjie on 16/8/11.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag: NSObject {
    
    var tagL = "<";
    
    var tagR = ">";
    
    var tagEnd = "/";
    
    var tagSpace = " ";
    
    var tagQuote = "\"";
    
    var tagEqual = "=";
    
    var tagName = "";
    
    var codeKey = "";
        
    var markdownTag = [String]();
    
    var tagValue = Dictionary<String,String>();
    
    var range: NSRange;
    
    var string: String;
    
    var index: Int;
    
    init(range: NSRange, string: String) {
        self.range = range;
        self.string = string;
        self.index = 0;
    }
    
    init(range: NSRange, string: String, index: Int){
        self.range = range;
        self.string = string;
        self.index = index;
    }
    
    func getParamObejct() -> Dictionary<String, AnyObject>{
        return [:];
    }
    
    func getString() -> String{
        var str = self.string;
        for tag in self.markdownTag {
            str = str.stringByReplacingOccurrencesOfString(tag, withString: "")
        }
        return str;
    }
    
    func getId() -> String{
        return self.tagName + "id_" + String(self.index);
    }
    
    func getHtml(index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        var str = self.string;
        for tag in self.markdownTag {
            str = str.stringByReplacingOccurrencesOfString(tag, withString: "")
        }
        return self.getHtml4Prefix() + self.handlerTransferString(str) + self.getHtml4Suffix()
    }
    
    func getHtml4Prefix() -> String{
        var result = self.tagL + self.tagName;
        if tagValue.count > 0 {
            for name in tagValue.keys {
                result += self.tagSpace + name + self.tagEqual + self.tagQuote+tagValue[name]!+self.tagQuote;
            }
        }
        return result + self.tagR;
    }
    
    func getHtml4Suffix() -> String{
        return self.tagL + self.tagEnd + self.tagName  + self.tagR;
    }
    
    func handlerTransferString(string: String) -> String{
        return string.stringByReplacingOccurrencesOfString("<", withString: "&lt;").stringByReplacingOccurrencesOfString(">", withString: "&gt;");
    }
}
