//
//  MarkdownHtmlTag4img1.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4img1: MarkdownHtmlTagLine {

    override init(range: NSRange, string: String){
        super.init(range: range, string: string);
        super.tagName = "img";
        super.markdownTag = ["!","[","]","(",")"];
    }
    
    override func getHtml(_ index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        if string == ""{
            return super.getHtml(index, object: object);
        }
        var result = string;
        do{
            //处理src
            let regex = try NSRegularExpression(pattern: "(\\((.)*\\))", options: [.caseInsensitive, .anchorsMatchLines]);
            let textCheckingResult = regex.firstMatch(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count));
            if textCheckingResult != nil {
                let range = string.characters.index(string.startIndex, offsetBy: textCheckingResult!.range.location+1)..<string.characters.index(string.startIndex, offsetBy: textCheckingResult!.range.location+textCheckingResult!.range.length-1);
                super.tagValue["src"] = string.substring(with: range);
                result.removeSubrange(range);
                string.removeSubrange(range);
            }
            //处理width
            let regexW = try NSRegularExpression(pattern: "(-w\\d{1,3}\\])", options: [.anchorsMatchLines]);
            let textCheckingResultW = regexW.firstMatch(in: result, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, result.characters.count));
            if textCheckingResultW != nil {
                let range = result.characters.index(result.startIndex, offsetBy: textCheckingResultW!.range.location)..<result.characters.index(result.startIndex, offsetBy: textCheckingResultW!.range.location+textCheckingResultW!.range.length-1);
                super.tagValue["style"] = "width:"+result.substring(with: range).replacingOccurrences(of: "-w", with: "")+"px;";
                result.removeSubrange(range);
                string.removeSubrange(range);
            }
            
            //处理alt
            let regexAlt = try NSRegularExpression(pattern: "(\\!\\[(.)*\\]\\(\\))", options: [.caseInsensitive, .anchorsMatchLines]);
            let textCheckingResultAlt = regexAlt.firstMatch(in: result, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, result.characters.count));
            if textCheckingResultAlt != nil {
                let range = result.characters.index(result.startIndex, offsetBy: textCheckingResultAlt!.range.location+2)..<result.characters.index(result.startIndex, offsetBy: textCheckingResultAlt!.range.location+textCheckingResultAlt!.range.length-3);
                super.tagValue["alt"] = result.substring(with: range);
                string.removeSubrange(range);
            }
        }catch{
            let nserror = error as NSError
            NSApplication.shared().presentError(nserror)
        }
        return super.getHtml(index, object: object);
    }
    
}
