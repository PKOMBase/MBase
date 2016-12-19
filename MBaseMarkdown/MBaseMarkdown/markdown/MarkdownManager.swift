//
//  MarkdownManager.swift
//  MBase
//
//  Created by sunjie on 16/8/9.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

public class MarkdownManager: NSObject {
    
    public enum CssType : String { 
        case None = "none"
        case Default = "default"
    }
    
    public static func generateHTMLForMarkdown(string: String, cssType: CssType  = .Default) -> NSString!{
        if string == "" {
            return "";
        }
        //外层段落
        let sourceString = self.getStructure(self.getP(string) as String);
        var resultMap = Dictionary<Int, String>();
        
        var ranges = [NSRange]();
        var rangeTemps: [NSRange];
        
        // 全局
        var objectDic = Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>();
        for tagRegex in MarkdownRegexCommonEnum.values {
            if ranges.count == 0 {
                ranges.append(NSMakeRange(0, sourceString.length));
            }
            var regex: NSRegularExpression?;
            do{
                regex =  try NSRegularExpression(pattern: tagRegex.rawValue, options: [.AnchorsMatchLines])
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
            rangeTemps = [NSRange]();
            for range in ranges {
                for textCheckingResult in regex!.matchesInString(sourceString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                    let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                    let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange, string: sourceString.substringWithRange(stringRange));
                    if objectDic[tagRegex] == nil{
                        objectDic[tagRegex] = [markdownHtmlTag.getParamObejct()];
                    }else {
                        objectDic[tagRegex]!.append(markdownHtmlTag.getParamObejct());
                    }
                    
                    rangeTemps.append(stringRange);
                }
            }
            // 腐蚀ranges
            ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
        }
        
        // 段落
        for tagRegex in MarkdownRegexParagraphEnum.values {
            if ranges.count == 0 {
                ranges.append(NSMakeRange(0, sourceString.length));
            }
            var regex: NSRegularExpression?;
            do{
                regex =  try NSRegularExpression(pattern: tagRegex.rawValue, options: [.DotMatchesLineSeparators])
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
            rangeTemps = [NSRange]();
            var i = 1;
            for range in ranges {
                for textCheckingResult in regex!.matchesInString(sourceString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                    let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                    let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange, string: sourceString.substringWithRange(stringRange));
                    resultMap[stringRange.location] = markdownHtmlTag.getHtml(i, object: objectDic)
                    rangeTemps.append(stringRange);
                    i += 1;
                }
            }
            // 腐蚀ranges
            ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
        }
        
        // 头
        for tagRegex in MarkdownRegexHeaderEnum.values {
            var regex: NSRegularExpression?;
            do{
                regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.AnchorsMatchLines])
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
            rangeTemps = [NSRange]();
            var i = 1;
            for range in ranges {
                for textCheckingResult in regex!.matchesInString(sourceString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                    let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                    let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange, string: sourceString.substringWithRange(stringRange), index: i);
                    resultMap[stringRange.location] = markdownHtmlTag.getHtml(i, object: objectDic)
                    rangeTemps.append(stringRange);
                    //拼装header
                    if objectDic[MarkdownRegexCommonEnum.HEADER] == nil{
                        objectDic[MarkdownRegexCommonEnum.HEADER] = [markdownHtmlTag.getParamObejct()];
                    }else {
                        objectDic[MarkdownRegexCommonEnum.HEADER]!.append(markdownHtmlTag.getParamObejct());
                    }
                    i += 1;
                }
            }
            // 腐蚀ranges
            ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
        }
        
        // 行
        for tagRegex in MarkdownRegexLineEnum.values {
            var regex: NSRegularExpression?;
            do{
                regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.AnchorsMatchLines])
            }catch{
                let nserror = error as NSError
                NSApplication.sharedApplication().presentError(nserror)
            }
                        rangeTemps = [NSRange]();
            var i = 1;
            for range in ranges {
                for textCheckingResult in regex!.matchesInString(sourceString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                    let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                    let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange, string: sourceString.substringWithRange(stringRange));
                    resultMap[stringRange.location] = markdownHtmlTag.getHtml(i, object: objectDic)
                    rangeTemps.append(stringRange);
                    i += 1;
                }
            }
            // 腐蚀ranges
            ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
        }
        
        //TOC
//        do{
//            regex = try NSRegularExpression(pattern: "((<p>> )\\[TOC\\]</p>)", options: [.AnchorsMatchLines])
//        }catch{
//            let nserror = error as NSError
//            NSApplication.sharedApplication().presentError(nserror)
//        }
                //        for range in ranges {
        //            for textCheckingResult in regex!.matchesInString(theString as String, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, theString.length)){
        //                var stringRange = textCheckingResult.range;
        //                var stringTemp = theString.substringWithRange(stringRange);
        //
        //
        //                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("<p>> ", withString: "<blockquote>", options: [.RegularExpressionSearch], range: NSMakeRange(0,  stringTemp.characters.count));
        //                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("<br/>> ", withString: "<br/>", options: [.RegularExpressionSearch],range: NSMakeRange(0,  stringTemp.characters.count));
        //                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("</p>", withString: "</blockquote>", options: [.RegularExpressionSearch],range: NSMakeRange(0,  stringTemp.characters.count));
        //                resultMap[stringRange.location] = stringTemp;
        //                rangeTemps.append(stringRange);
        //                // 腐蚀ranges
        //                ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
        //            }
        //        }

        
        // 剩余的，正常文本
        for range in ranges {
            resultMap[range.location] = sourceString.substringWithRange(range);
        }
        
        // 组合
        var result = "";
        for key in resultMap.keys.sort(<) {
            result += resultMap[key]!;
        }
        
        //增加资源
        if cssType != .None {
            result = "<html><head><script type='text/javascript' src='prettify.js')></script><link rel='stylesheet' type='text/css' href='prettify.css'><link rel='stylesheet' type='text/css' href='" + cssType.rawValue + ".css' ></head><body onload='prettyPrint()'>\n" + result + "</body></html>";
        }
        return result;
    }
    
    static func getP(string: String) -> NSString{
        //外层段落
        var result = NSString(string: "<p>" + string + "</p>");
        result = result.stringByReplacingOccurrencesOfString("\n", withString: "</p><p>");
//        result = result.stringByReplacingOccurrencesOfString("<p></p>", withString: "");
        result = result.stringByReplacingOccurrencesOfString("((</p><p>){2,})", withString: "</p>\n<p>", options: [.RegularExpressionSearch], range: NSMakeRange(0, result.length ));
        result = result.stringByReplacingOccurrencesOfString("((</p><p>){1})", withString: "<br/>", options: [.RegularExpressionSearch], range: NSMakeRange(0, result.length));
//        result = result.stringByReplacingOccurrencesOfString("<p></p>", withString: "");
//        result = result.stringByReplacingOccurrencesOfString("<p><br/>", withString: "");
        return result;
    }
    
    static func getStructure(string: String) -> NSString{
        var theString = NSString(string: string);
        
        
        var rangeTemps: [NSRange];
        rangeTemps = [NSRange]();
        
        var ranges = [NSRange]();
        if ranges.count == 0 {
            ranges.append(NSMakeRange(0, theString.length));
        }
    
        var resultMap = Dictionary<Int, String>();
        
        
        var regex: NSRegularExpression?;
        
        // header
        do{
            regex = try NSRegularExpression(pattern: "(^(<p>\\#{1,6} )((.)*</p>))", options: [.AnchorsMatchLines])
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        for range in ranges {
            for textCheckingResult in regex!.matchesInString(theString as String, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, theString.length)) {
                let stringRange = textCheckingResult.range;
                var stringTemp = theString.substringWithRange(stringRange);
                //确定header类型
                let keyNum = NSString(string: stringTemp).rangeOfString("(\\#{1,6} )", options: [.RegularExpressionSearch], range: NSMakeRange(0,  stringTemp.characters.count)).length - 1;
                var keyString = "";
                for _ in 1...keyNum {
                    keyString += "#";
                }
                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("<p>\\#{1,6} ", withString: keyString+" ", options: [.RegularExpressionSearch], range: NSMakeRange(0,  stringTemp.characters.count));
                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("<br/>\\#{1,6} ", withString: "\n"+keyString+" ", options: [.RegularExpressionSearch],range: NSMakeRange(0,  stringTemp.characters.count));
                //如果还有<br/>
                if NSString(string: stringTemp).rangeOfString("<br/>").length > 0 {
                    stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("<br/>", withString: "\n<p>", options: [.RegularExpressionSearch],range: NSMakeRange(0,  stringTemp.characters.count));
                }else{
                    stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("</p>", withString: "", options: [.RegularExpressionSearch], range: NSMakeRange(0,  stringTemp.characters.count));
                }
                resultMap[stringRange.location] = stringTemp;
                rangeTemps.append(stringRange);
                // 腐蚀ranges
                ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
            }
        }
        
        // 普通序列
        do{
            regex = try NSRegularExpression(pattern: "((<p>\\* )(.)*</p>)", options: [.AnchorsMatchLines])
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        for range in ranges {
            for textCheckingResult in regex!.matchesInString(theString as String, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, theString.length)){
                var stringRange = textCheckingResult.range;
                var stringTemp = theString.substringWithRange(stringRange);
                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("<p>\\* ", withString: "<ul><li>", options: [.RegularExpressionSearch], range: NSMakeRange(0,  stringTemp.characters.count));
                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("<br/>\\* ", withString: "</li><li>", options: [.RegularExpressionSearch],range: NSMakeRange(0,  stringTemp.characters.count));
                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("</p>", withString: "</li></ul>", options: [.RegularExpressionSearch],range: NSMakeRange(0,  stringTemp.characters.count));
                resultMap[stringRange.location] = stringTemp;
                rangeTemps.append(stringRange);
                // 腐蚀ranges
                ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
            }
        }
        
        // 有序号序列
        do{
            regex = try NSRegularExpression(pattern: "((<p>\\d{1,2}. )(.)*</p>)", options: [.AnchorsMatchLines])
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        for range in ranges {
            for textCheckingResult in regex!.matchesInString(theString as String, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, theString.length)){
                var stringRange = textCheckingResult.range;
                var stringTemp = theString.substringWithRange(stringRange);
                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("<p>\\d{1,2}. ", withString: "<ol><li>", options: [.RegularExpressionSearch], range: NSMakeRange(0,  stringTemp.characters.count));
                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("<br/>\\d{1,2}. ", withString: "</li><li>", options: [.RegularExpressionSearch],range: NSMakeRange(0,  stringTemp.characters.count));
                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("</p>", withString: "</li></ol>", options: [.RegularExpressionSearch],range: NSMakeRange(0,  stringTemp.characters.count));
                resultMap[stringRange.location] = stringTemp;
                rangeTemps.append(stringRange);
                // 腐蚀ranges
                ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
            }
        }
        
        // 引用
        do{
            regex = try NSRegularExpression(pattern: "((<p>> )(.)*</p>)", options: [.AnchorsMatchLines])
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        for range in ranges {
            for textCheckingResult in regex!.matchesInString(theString as String, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, theString.length)){
                var stringRange = textCheckingResult.range;
                var stringTemp = theString.substringWithRange(stringRange);
                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("<p>> ", withString: "<blockquote>", options: [.RegularExpressionSearch], range: NSMakeRange(0,  stringTemp.characters.count));
                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("<br/>> ", withString: "<br/>", options: [.RegularExpressionSearch],range: NSMakeRange(0,  stringTemp.characters.count));
                stringTemp = NSString(string: stringTemp).stringByReplacingOccurrencesOfString("</p>", withString: "</blockquote>", options: [.RegularExpressionSearch],range: NSMakeRange(0,  stringTemp.characters.count));
                resultMap[stringRange.location] = stringTemp;
                rangeTemps.append(stringRange);
                // 腐蚀ranges
                ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
            }
        }
        
        // 剩余的，正常文本
        for range in ranges {
            resultMap[range.location] = theString.substringWithRange(range);
        }
        // 组合
        var result = "";
        for key in resultMap.keys.sort(<) {
            result += resultMap[key]!;
        }
        return result;
    }

}
