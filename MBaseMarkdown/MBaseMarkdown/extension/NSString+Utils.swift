//
//  NSString+Utils.swift
//  MBase
//
//  Created by sunjie on 16/8/28.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension NSString {
    
    func rangeOfString(searchString: NSString, exceptStrings: [String], options: NSStringCompareOptions, range: NSRange) -> NSRange {
        if exceptStrings.count <= 0{
            return self.rangeOfString(searchString as String, options: options, range: range);
        }
        var stringTemp = NSString(string: self);
        for exceptString in exceptStrings {
            stringTemp = stringTemp.stringByReplacingOccurrencesOfString(exceptString, withString: "000", options: options, range: range)
        }
        return stringTemp.rangeOfString(searchString as String, options: options, range: range);
    }
    
    func isExistString(searchString: NSString) -> Bool {
        let range = self.rangeOfString(searchString as String);
        return range.length <= 0;
    }
    
    func isExistString(searchString: NSString, range: NSRange) -> Bool {
        let range = self.rangeOfString(searchString as String, options: NSStringCompareOptions(rawValue: 0), range: range);
        return range.length <= 0;
    }
    
    func countOccurencesOfString(searchString: NSString) -> Int {
        if searchString.length == 0{
            return 0;
        }
        let strCount = self.length - self.stringByReplacingOccurrencesOfString(searchString as String, withString: "").characters.count;
        return strCount / searchString.length;
    }
    
    func countOccurencesOfString(searchString: NSString, range: NSRange) -> Int{
        if searchString.length == 0{
            return 0;
        }
        let string = self.substringWithRange(range) as NSString;
        let strCount = string.length - string.stringByReplacingOccurrencesOfString(searchString as String
            , withString: "").characters.count;
        return strCount / searchString.length;
    }
    
    func countOccurencesOfString(searchString: NSString, exceptStrings: [String], range: NSRange) -> Int{
        let count1 = self.countOccurencesOfString(searchString, range: range);
        if count1 <= 0 {
            return 0;
        }
        var count2 = 0;
        for exceptString in exceptStrings {
            count2 += self.countOccurencesOfString(exceptString, range: range);
        }
        return count1 - count2;
    }
    
    
    
}
