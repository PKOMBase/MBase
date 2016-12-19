//
//  MarkdownManager.swift
//  MBase
//
//  Created by sunjie on 16/8/9.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

public class MarkdownEditManager: NSObject {
    
    var textStorage: NSTextStorage;
    
    public init(textStorage: NSTextStorage) {
        self.textStorage = textStorage;
    }
    
    public func changeTextFont(selectedRange: NSRange, editedRange: NSRange) -> String {
        
        // 全文
        let textString = NSString(string: self.textStorage.string);
        // 选择行
        let lineRange = NSUnionRange(selectedRange, textString.lineRangeForRange(editedRange));
        // 上半段
        let preRange = NSMakeRange(0, lineRange.location);
        // 下半段
        let backRange = NSMakeRange(NSMaxRange(lineRange), textString.length - NSMaxRange(lineRange));
        
        // 段落
        var ranges = [NSRange]();
        var rangeTemps: [NSRange];
        for tagRegex in MarkdownRegexParagraphEnum.values {
            if tagRegex.rawValue == "" || tagRegex.codeKey == "" {
                continue;
            }
            if ranges.count == 0 {
//                let changeRange = self.getChangeRange(tagRegex, string: textString, lineRange: lineRange, preRange: preRange, backRange: backRange);
                let changeRange = NSMakeRange(0, textString.length);
                ranges.append(changeRange);
                // 默认
                self.applyStylesToRange4Default(changeRange);
            }
            rangeTemps = self.applyStylesToRange4Paragraph(tagRegex, textString: textString, ranges: ranges);
            // 腐蚀ranges
            ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
        }
        
        // 列表
        for tagRegex in MarkdownRegexListEnum.values {
            self.applyStylesToRange4List(tagRegex, textString: textString, ranges: ranges);
        }
        
        // 头
        for tagRegex in MarkdownRegexHeaderEnum.values {
            self.applyStylesToRange4Header(tagRegex, textString: textString, ranges: ranges);
        }

        // 行
        for tagRegex in MarkdownRegexLineEnum.values {
            self.applyStylesToRange4Line(tagRegex, textString: textString, ranges: ranges);
        }
        
        return self.textStorage.string;
        
    }
    
    public func handlerInitFont(){
        // 全文
        let textString = NSString(string: self.textStorage.string);
        
        let changeRange = NSMakeRange(0, textString.length);
        // 默认
        self.applyStylesToRange4Default(changeRange);
        // 段落
        var ranges = [changeRange];
        var rangeTemps: [NSRange];
        for tagRegex in MarkdownRegexParagraphEnum.values {
            if tagRegex.rawValue == "" || tagRegex.codeKey == "" {
                continue;
            }
            rangeTemps = self.applyStylesToRange4Paragraph(tagRegex, textString: textString, ranges: ranges);
            // 腐蚀ranges
            ranges = MarkdownCommonUtils.corrodeString(ranges, corrodeRanges: rangeTemps);
        }
        
        // 列表
        for tagRegex in MarkdownRegexListEnum.values {
            self.applyStylesToRange4List(tagRegex, textString: textString, ranges: ranges);
        }
        
        // 头
        for tagRegex in MarkdownRegexHeaderEnum.values {
            self.applyStylesToRange4Header(tagRegex, textString: textString, ranges: ranges);
        }
        
        // 行
        for tagRegex in MarkdownRegexLineEnum.values {
            self.applyStylesToRange4Line(tagRegex, textString: textString, ranges: ranges);
        }
        
        // 公共
        for tagRegex in MarkdownRegexCommonEnum.values {
            self.applyStylesToRange4Common(tagRegex, textString: textString, ranges: ranges);
        }
    }
    
    // 获取段与段间，以```为例。思路：按选择行将文章分为两份，上半份倒查段的关键字；下半份正查段的关键字。
    /** 对于上半段:
     1. 如果出现了偶数个相同关键字，则说明selectedRange不在对应code中，这时需要判断下半段：
     1.1 如果下半段没有关键字，则处理单行；
     1.2 如果下半段有关键字，则处理选择行行首到文章尾；
     2. 如果出现了奇数个相同关键字，则说明选择行在对应code中，，这时需要判断下半段：
     2.1 如果下半段没有关键字，则处理上半段关键字到选择行行尾；
     2.2 如果下半段有关键字，则处理上半段关键字到文章尾；
     **/
    /** 对于下半段:
     配合上半段处理。
     **/
    func getChangeRange(tagRegex : MarkdownRegexParagraphEnum, string: NSString, lineRange: NSRange, preRange: NSRange,  backRange: NSRange) -> NSRange{
        let codeKey = tagRegex.codeKey;
        // 上半段最近的段关键字
        let preCodeKeyRange = string.rangeOfString(codeKey, options: .BackwardsSearch , range: preRange);
        // 下半段最近的段关键字
        let backCodeKeyRange = string.rangeOfString(codeKey, options: NSStringCompareOptions(rawValue: 0), range: backRange);
        // 上半段，段关键字出现次数
        let preCount = string.countOccurencesOfString(codeKey, range: preRange);
        // 处理关键字
        var changeRangeTemp: NSRange!;
        if preCount%2 == 0 {
            if backCodeKeyRange.length <= 0 {
                // 选择行首到选择行尾
                changeRangeTemp = lineRange;
            } else {
                // 选择行行首到文章尾
                changeRangeTemp = NSMakeRange(lineRange.location, NSString(string: string).length - lineRange.location);
            }
        } else if preCount%2 == 1 {
            if backCodeKeyRange.length <= 0 {
                // 上半段关键字到选择行行尾
                changeRangeTemp = NSMakeRange(preCodeKeyRange.location, NSMaxRange(lineRange) - preCodeKeyRange.location);
            } else {
                // 上半段关键字到文章尾
                changeRangeTemp = NSMakeRange(preCodeKeyRange.location, NSString(string: string).length - preCodeKeyRange.location);
            }
        }
        return changeRangeTemp;
    }
    
    func applyStylesToRange4Default(range: NSRange){
        let normalAttributes = [NSParagraphStyleAttributeName : MarkdownConstsManager.getDefaultParagraphStyle(), NSFontAttributeName : NSFont.systemFontOfSize(MarkdownConstsManager.defaultFontSize), NSForegroundColorAttributeName : MarkdownConstsManager.defaultFontColor];
        self.textStorage.addAttributes(normalAttributes, range: range);
    }
    
    func applyStylesToRange4Paragraph(tagRegex : MarkdownRegexParagraphEnum, textString: NSString, ranges: [NSRange]) -> [NSRange]{
        var regex: NSRegularExpression?;
        do{
            regex =  try NSRegularExpression(pattern: tagRegex.rawValue, options: [.DotMatchesLineSeparators])
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        let attrs = MarkdownEditFactory.getMarkdownAttributes(tagRegex);
        if attrs.count <= 0  {
            return ranges;
        }
        var rangeTemps = [NSRange]();
        for range in ranges {
            for textCheckingResult in regex!.matchesInString(textString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                let stringRange = NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length);
                self.textStorage.addAttributes(attrs, range: stringRange);
                rangeTemps.append(stringRange);
            }
        }
        return rangeTemps;
    }
    
    func applyStylesToRange4Header(tagRegex : MarkdownRegexHeaderEnum, textString: NSString, ranges: [NSRange]) {
        var regex: NSRegularExpression?;
        do{
            regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.AnchorsMatchLines])
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        let attrs = MarkdownEditFactory.getMarkdownAttributes(tagRegex);
        if attrs.count <= 0  {
            return;
        }
        for range in ranges {
            for textCheckingResult in regex!.matchesInString(textString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                self.textStorage.addAttributes(attrs, range: NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length));
            }
        }
    }
    
    func applyStylesToRange4Line(tagRegex : MarkdownRegexLineEnum, textString: NSString, ranges: [NSRange]) {
        var regex: NSRegularExpression?;
        do{
            regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.AnchorsMatchLines])
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        let attrs = MarkdownEditFactory.getMarkdownAttributes(tagRegex);
        if attrs.count <= 0  {
            return;
        }
        for range in ranges {
            for textCheckingResult in regex!.matchesInString(textString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                self.textStorage.addAttributes(attrs, range: NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length));
            }
        }
    }
    
    func applyStylesToRange4List(tagRegex : MarkdownRegexListEnum, textString: NSString, ranges: [NSRange]){
        var regex: NSRegularExpression?;
        do{
            regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.AnchorsMatchLines])
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        let attrs = MarkdownEditFactory.getMarkdownAttributes(tagRegex);
        if attrs.count <= 0  {
            return;
        }
        for range in ranges {
            for textCheckingResult in regex!.matchesInString(textString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                self.textStorage.addAttributes(attrs, range: NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length));
            }
        }
    }
    
    
    func applyStylesToRange4Common(tagRegex : MarkdownRegexCommonEnum, textString: NSString, ranges: [NSRange]) {
        var regex: NSRegularExpression?;
        do{
            regex = try NSRegularExpression(pattern: tagRegex.rawValue, options: [.AnchorsMatchLines])
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        let attrs = MarkdownEditFactory.getMarkdownAttributes(tagRegex);
        if attrs.count <= 0  {
            return;
        }
        for range in ranges {
            for textCheckingResult in regex!.matchesInString(textString.substringWithRange(range), options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, range.length)) {
                self.textStorage.addAttributes(attrs, range: NSMakeRange(range.location+textCheckingResult.range.location, textCheckingResult.range.length));
            }
        }
    }
}
