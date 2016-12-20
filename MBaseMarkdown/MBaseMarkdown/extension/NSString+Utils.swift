//
//  NSString+Utils.swift
//  MBase
//
//  Created by sunjie on 16/8/28.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension NSString {
    
    func rangeOfString(_ searchString: NSString, exceptStrings: [String], options: NSString.CompareOptions, range: NSRange) -> NSRange {
        if exceptStrings.count <= 0{
            return self.range(of: searchString as String, options: options, range: range);
        }
        var stringTemp = NSString(string: self);
        for exceptString in exceptStrings {
            stringTemp = stringTemp.replacingOccurrences(of: exceptString, with: "000", options: options, range: range) as NSString
        }
        return stringTemp.range(of: searchString as String, options: options, range: range);
    }
    
    func isExistString(_ searchString: NSString) -> Bool {
        let range = self.range(of: searchString as String);
        return range.length <= 0;
    }
    
    func isExistString(_ searchString: NSString, range: NSRange) -> Bool {
        let range = self.range(of: searchString as String, options: NSString.CompareOptions(rawValue: 0), range: range);
        return range.length <= 0;
    }
    
    func countOccurencesOfString(_ searchString: NSString) -> Int {
        if searchString.length == 0{
            return 0;
        }
        let strCount = self.length - self.replacingOccurrences(of: searchString as String, with: "").characters.count;
        return strCount / searchString.length;
    }
    
    func countOccurencesOfString(_ searchString: NSString, range: NSRange) -> Int{
        if searchString.length == 0{
            return 0;
        }
        let string = self.substring(with: range) as NSString;
        let strCount = string.length - string.replacingOccurrences(of: searchString as String
            , with: "").characters.count;
        return strCount / searchString.length;
    }
    
    func countOccurencesOfString(_ searchString: NSString, exceptStrings: [String], range: NSRange) -> Int{
        let count1 = self.countOccurencesOfString(searchString, range: range);
        if count1 <= 0 {
            return 0;
        }
        var count2 = 0;
        for exceptString in exceptStrings {
            count2 += self.countOccurencesOfString(exceptString as NSString, range: range);
        }
        return count1 - count2;
    }
    
    
    
}
