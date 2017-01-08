//
//  MarkdownManager.swift
//  MBase
//
//  Created by sunjie on 16/8/9.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

open class MarkdownManager: NSObject {
     
     public enum CssType : String {
          case None = "none"
          case Default = "default"
     }
     
     open static func generateHTMLForMarkdown(_ string: String, cssType: CssType  = .Default) -> NSString!{
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
                    regex =  try NSRegularExpression(pattern: tagRegex.rawValue, options: [.anchorsMatchLines])
               }catch{
                    let nserror = error as NSError
                    NSApplication.shared().presentError(nserror)
               }
               var i = 1;
               rangeTemps = [NSRange]();
               for range in ranges {
                    for textCheckingResult in regex!.matches(in: sourceString.substring(with: range), options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                         let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                         let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange, string: sourceString.substring(with: stringRange));
                         if objectDic[tagRegex] == nil{
                              objectDic[tagRegex] = [markdownHtmlTag.getParamObejct(index: i)];
                         }else {
                              objectDic[tagRegex]!.append(markdownHtmlTag.getParamObejct(index: i));
                         }
                         rangeTemps.append(stringRange);
                         i += 1;
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
                    regex =  try NSRegularExpression(pattern: tagRegex.rawValue, options: [.dotMatchesLineSeparators])
               }catch{
                    let nserror = error as NSError
                    NSApplication.shared().presentError(nserror)
               }
               rangeTemps = [NSRange]();
               var i = 1;
               for range in ranges {
                    for textCheckingResult in regex!.matches(in: sourceString.substring(with: range), options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                         let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                         let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange, string: sourceString.substring(with: stringRange));
                         resultMap[stringRange.location] = markdownHtmlTag.getHtml(i, object: objectDic)
                         rangeTemps.append(stringRange);
                         i += 1;
                    }
               }
               // 腐蚀ranges
               ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
          }
          
          // 标题
          var i = 1;
          for tagRegex in MarkdownRegexHeaderEnum.values4Html {
               var regex: NSRegularExpression?;
               do{
                    regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.anchorsMatchLines])
               }catch{
                    let nserror = error as NSError
                    NSApplication.shared().presentError(nserror)
               }
               rangeTemps = [NSRange]();
               var level = 0;
               var html = "";
               var rootTree = Tree(id: 0, level: 0, name: "root");
               var lastTree: Tree?;
               var nowTree: Tree?;
               for range in ranges {
                    for textCheckingResult in regex!.matches(in: sourceString.substring(with: range), options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                         let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                         let str = sourceString.substring(with: stringRange)
                         let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange, string: str, index: i);
                         //组装目录树
                         level = markdownHtmlTag.level;
                         nowTree = Tree(id: i, level: level, name: markdownHtmlTag.getString());
                         if nil == lastTree {
                              lastTree = rootTree;
                         }
                         // 追加
                         if (level > lastTree!.level) {
                              lastTree!.addChild(tree: nowTree!);
                         } else {
                              lastTree!.addParentChild(tree: nowTree!);
                         }
                         lastTree = nowTree;
                         
                         resultMap[stringRange.location] = markdownHtmlTag.getHtml(i, object: objectDic);
                         rangeTemps.append(stringRange);
                         i += 1;
                    }
               }
               // 腐蚀ranges
               ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
               
               //将目录树放入objectDic
               if objectDic[MarkdownRegexCommonEnum.HEADER] == nil{
                    objectDic[MarkdownRegexCommonEnum.HEADER] = [["TOC":rootTree]];
               }
          }
          
          // 行
          for tagRegex in MarkdownRegexLineEnum.values {
               var regex: NSRegularExpression?;
               do{
                    regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.anchorsMatchLines])
               }catch{
                    let nserror = error as NSError
                    NSApplication.shared().presentError(nserror)
               }
               rangeTemps = [NSRange]();
               var i = 1;
               for range in ranges {
                    for textCheckingResult in regex!.matches(in: sourceString.substring(with: range), options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                         let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                         let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange, string: sourceString.substring(with: stringRange));
                         if tagRegex == MarkdownRegexLineEnum.TOC {
                              resultMap[stringRange.location] = (markdownHtmlTag as! MarkdownHtmlTag4toc).getHtml(i, allString: string as String, object: objectDic);
                         }else{
                              resultMap[stringRange.location] = markdownHtmlTag.getHtml(i, object: objectDic)
                         }
                         rangeTemps.append(stringRange);
                         i += 1;
                    }
               }
               // 腐蚀ranges
               ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
          }
          
          // 剩余的，正常文本
          for range in ranges {
               resultMap[range.location] = sourceString.substring(with: range);
          }
          
          // 组合
          var result = "";
          for key in resultMap.keys.sorted(by: <) {
               result += resultMap[key]!;
          }
          
          // 注脚
          if objectDic[MarkdownRegexCommonEnum.FOOT] != nil{
               //现根据index排序
               objectDic[MarkdownRegexCommonEnum.FOOT]!.sort(by: { (dic1: Dictionary<String, AnyObject>, dic2: Dictionary<String, AnyObject>) -> Bool in
                    let tag1 = (dic1[dic1.keys.first!] as! MarkdownHtmlTagCommon);
                    let tag2 = (dic2[dic2.keys.first!] as! MarkdownHtmlTagCommon);
                    return tag1.index < tag2.index;
               })
               var foot = "<div class=\"foot\"><hr/><ol>";
               for footNote in objectDic[MarkdownRegexCommonEnum.FOOT]! {
                    for idString in footNote.keys{
                         foot += (footNote[idString] as! MarkdownHtmlTagCommon).getHtml(0, object: [:]);
                    }
               }
               foot += "</ol></div>";
               result += foot;
          }
          
          //增加资源
          if cssType != .None {
               result = "<html><head><script type='text/javascript' src='prettify.js')></script><link rel='stylesheet' type='text/css' href='prettify.css'><link rel='stylesheet' type='text/css' href='" + cssType.rawValue + ".css' ></head><body onload='prettyPrint()'>\n" + result + "</body></html>";
          }
          return result as NSString!;
     }
     
     static func getP(_ string: String) -> NSString{
          //外层段落
          var result = NSString(string: "<p>" + string + "</p>");
          result = result.replacingOccurrences(of: "\n", with: "</p><p>") as NSString;
          result = result.replacingOccurrences(of: "((</p><p>){2,})", with: "</p>\n<p>", options: [.regularExpression], range: NSMakeRange(0, result.length )) as NSString;
          result = result.replacingOccurrences(of: "((</p><p>){1})", with: "<br/>", options: [.regularExpression], range: NSMakeRange(0, result.length)) as NSString;
          return result;
     }
     
     static func getStructure(_ string: String) -> NSString{
          var sourceString = NSString(string: string);
          
          
          var rangeTemps: [NSRange];
          rangeTemps = [NSRange]();
          
          var ranges = [NSRange]();
          if ranges.count == 0 {
               ranges.append(NSMakeRange(0, sourceString.length));
          }
          
          var resultMap = Dictionary<Int, String>();
          
          
          var regex: NSRegularExpression?;
          
          // 标题
          do{
               regex = try NSRegularExpression(pattern: "(^(<p>\\#{1,6} )((.)*</p>))", options: [.anchorsMatchLines])
          }catch{
               let nserror = error as NSError
               NSApplication.shared().presentError(nserror)
          }
          for range in ranges {
               for textCheckingResult in regex!.matches(in: sourceString as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, sourceString.length)) {
                    let stringRange = textCheckingResult.range;
                    var stringTemp = sourceString.substring(with: stringRange);
                    //确定header类型
                    let keyNum = NSString(string: stringTemp).range(of: "(\\#{1,6} )", options: [.regularExpression], range: NSMakeRange(0,  stringTemp.characters.count)).length - 1;
                    var keyString = "";
                    for _ in 1...keyNum {
                         keyString += "#";
                    }
                    stringTemp = NSString(string: stringTemp).replacingOccurrences(of: "<p>\\#{1,6} ", with: keyString+" ", options: [.regularExpression], range: NSMakeRange(0,  stringTemp.characters.count));
                    stringTemp = NSString(string: stringTemp).replacingOccurrences(of: "<br/>\\#{1,6} ", with: "\n"+keyString+" ", options: [.regularExpression],range: NSMakeRange(0,  stringTemp.characters.count));
                    //如果还有<br/>
                    if NSString(string: stringTemp).range(of: "<br/>").length > 0 {
                         stringTemp = NSString(string: stringTemp).replacingOccurrences(of: "<br/>", with: "\n<p>", options: [.regularExpression],range: NSMakeRange(0,  stringTemp.characters.count));
                    }else{
                         stringTemp = NSString(string: stringTemp).replacingOccurrences(of: "</p>", with: "", options: [.regularExpression], range: NSMakeRange(0,  stringTemp.characters.count));
                    }
                    resultMap[stringRange.location] = stringTemp;
                    rangeTemps.append(stringRange);
                    // 腐蚀ranges
                    ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
               }
          }
          
          //序列
          for tagRegex in MarkdownRegexListEnum.values4Html {
               if ranges.count == 0 {
                    ranges.append(NSMakeRange(0, sourceString.length));
               }
               var regex: NSRegularExpression?;
               do{
                    regex =  try NSRegularExpression(pattern: tagRegex.rawValue, options: [.anchorsMatchLines])
               }catch{
                    let nserror = error as NSError
                    NSApplication.shared().presentError(nserror)
               }
               rangeTemps = [NSRange]();
               var i = 1;
               for range in ranges {
                    for textCheckingResult in regex!.matches(in: sourceString.substring(with: range), options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                         let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                         let markdownHtmlTag = MarkdownHtmlTagFactory.getMarkdownHtmlTag(tagRegex, range: stringRange, string: sourceString.substring(with: stringRange));
                         resultMap[stringRange.location] = markdownHtmlTag.getHtml(i, object: [:])
                         rangeTemps.append(stringRange);
                         i += 1;
                    }
               }
               // 腐蚀ranges
               ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
          }
          
          // 剩余的，正常文本
          for range in ranges {
               resultMap[range.location] = sourceString.substring(with: range);
          }
          // 组合
          var result = "";
          for key in resultMap.keys.sorted(by: <) {
               result += resultMap[key]!;
          }
          return result as NSString;
     }
     
}
