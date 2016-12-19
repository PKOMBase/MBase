//
//  CommonUtils.swift
//  MBase
//
//  Created by sunjie on 16/8/30.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownCommonUtils: NSObject {

    //获取两个NSRange的最大区间
    static func getMaxRange(range:NSRange, otherRange:NSRange) -> NSRange {
        let location = min(range.location, otherRange.location);
        let length = max(NSMaxRange(range), NSMaxRange(otherRange)) - location;
        return NSMakeRange(location, length);
    }
    
    
    static func isContainInCodeKey(string: NSString, codeKey: String, range: NSRange) -> Bool {
        // 上半段
        let preRange = NSMakeRange(0, range.location);
        let preCount = string.countOccurencesOfString(codeKey, range: preRange);
        if preCount%2 == 0 {
            return false;
        }
        // 下半段
        let backRange = NSMakeRange(range.location, string.length - range.location);
        if string.isExistString(codeKey, range: backRange) {
            return false;
        }
        return true;
    }
    
    //腐蚀制定ranges
    static func corrodeString(ranges: [NSRange], corrodeRanges: [NSRange]) -> [NSRange]{
        if ranges.count <= 0 || corrodeRanges.count <= 0{
            return ranges;
        }
        //获取range坑集合
        var holeRanges = [NSRange]();
        ranges.count
        for index in 0 ..< ranges.count+1 {
            // 起点
            if index == 0 {
                holeRanges.append(NSMakeRange(ranges[0].location, 0));
                continue;
            }
                //终点
            else if index == ranges.count {
                holeRanges.append(NSMakeRange(NSMaxRange(ranges[ranges.count - 1]), 0));
                continue;
            }
                //中间点
            else {
                holeRanges.append(NSMakeRange(NSMaxRange(ranges[index-1]), ranges[index].location - NSMaxRange(ranges[index-1])))
            }
        }
        
        //组装holeRanges，追加corrodeRanges并重排序
        holeRanges.appendContentsOf(corrodeRanges);
        holeRanges = holeRanges.sort({ r1, r2 in r1.location < r2.location })
        
        //腐蚀corrodeRanges
        var corrodeResults = [NSRange]();
        for index in 0 ..< holeRanges.count {
            if index == 0 {
                continue;
            } else if holeRanges[index].location > NSMaxRange(holeRanges[index-1]){
                corrodeResults.append(NSMakeRange(NSMaxRange(holeRanges[index-1]), holeRanges[index].location - NSMaxRange(holeRanges[index-1])));
            }
        }
        return corrodeResults;
    }
}
