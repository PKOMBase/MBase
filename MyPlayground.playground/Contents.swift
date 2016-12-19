//: Playground - noun: a place where people can play

import Cocoa

//var str = "# asdfassafasdfsda \n **asjflljksaljflsjlfkas**"
//
//let range = str.startIndex.advancedBy(1)..<str.startIndex.advancedBy(3);

//var ss = NSString(string:"qwer```tyuiop```a123123123123sdf```ghjll1")
//
//
//let s = NSString(string:"01`2```4`1````8```190");
//
//let range = NSMakeRange(0, s.length);
//    let searchString = "`"
//    
//    let exceptStrings = ["```"]
//    
//    if exceptStrings.count <= 0{
//        NSString(string: searchString).rangeOfString(searchString, options: .BackwardsSearch, range: range);
//    }
//    var stringTemp = NSString(string:  s);
//    for exceptString in exceptStrings {
//        stringTemp = stringTemp.stringByReplacingOccurrencesOfString(exceptString, withString: "000", options: .BackwardsSearch, range: range)
//    }
//stringTemp.rangeOfString(searchString, options: .BackwardsSearch, range: range).location
//
//
//腐蚀制定ranges
//func corrodeString(ranges: [NSRange], corrodeRanges: [NSRange]) -> [NSRange]{
//    //完整range
//    let fullRange: NSRange = NSMakeRange(ranges[0].location, NSMaxRange(ranges[ranges.count - 1]))
//    //获取range坑集合
//    var holeRanges = [NSRange]();
//    var i = 0;
//    for range in ranges {
//        if i >= ranges.count - 1 {
//            break;
//        }
//        holeRanges[i] = NSMakeRange(NSMaxRange(range), ranges[i+1].location);
//        i += 1;
//    }
//    //组装holeRanges，追加corrodeRanges并重排序
//    holeRanges.appendContentsOf(corrodeRanges);
//    holeRanges = holeRanges.sort({ r1, r2 in r1.location < r2.location })
//    //腐蚀corrodeRanges
//    var corrodeResults = [NSRange]();
//    let j = 0;
//    for holeRange in holeRanges {
//        if j >= holeRanges.count - 1 || NSMaxRange(holeRange) > NSMaxRange(fullRange){
//            break;
//        }
//        corrodeResults[i] = NSMakeRange(NSMaxRange(holeRange), holeRanges[i+1].location);
//        i += 1;
//    }
//    return corrodeResults;
//}


//let ranges = [NSMakeRange(0, 100), NSMakeRange(150, 50)]
//
//let corrodeRanges = [NSMakeRange(0, 15), NSMakeRange(30, 30), NSMakeRange(160, 20)]
//
////获取range坑集合
//var holeRanges = [NSRange]();
//ranges.count
//for index in 0 ..< ranges.count+1 {
//    if index == 0 {
//        holeRanges.append(NSMakeRange(ranges[0].location, 0));
//        continue;
//    } else if index == ranges.count {
//        holeRanges.append(NSMakeRange(NSMaxRange(ranges[ranges.count - 1]), 0));
//        continue;
//    } else {
//        holeRanges.append(NSMakeRange(NSMaxRange(ranges[index-1]), ranges[index].location - NSMaxRange(ranges[index-1])))
//    }
//}
//
////组装holeRanges，追加corrodeRanges并重排序
//holeRanges.appendContentsOf(corrodeRanges);
//holeRanges = holeRanges.sort({ r1, r2 in r1.location < r2.location })
//holeRanges
//for a in holeRanges{
//    a.location
//    a.length
//}
//
////腐蚀corrodeRanges
//var corrodeResults = [NSRange]();
//for index in 0 ..< holeRanges.count {
//    if index == 0 {
//        continue;
//    } else if holeRanges[index].location > NSMaxRange(holeRanges[index-1]){
//        corrodeResults.append(NSMakeRange(NSMaxRange(holeRanges[index-1]), holeRanges[index].location - NSMaxRange(holeRanges[index-1])));
//    }
//}
//
//for b in corrodeResults{
//    b.location
//    b.length
//}







//
//let date = NSDate()
//let calendar = NSCalendar.currentCalendar()
//var components = calendar.components([.Year, .Month], fromDate: date)
//let startOfMonth = calendar.dateFromComponents(components)!
//
//
//
//components = NSDateComponents()
//components.month = 1
//components.day = -1
//
//let endOfMonth =  calendar.dateByAddingComponents(components,
//                                                  toDate: startOfMonth,
//                                                  options: [])!
//components = NSDateComponents()
//components.day = 1
//
//let aa =  calendar.dateByAddingComponents(components,
//                                                  toDate: startOfMonth,
//                                                  options: [])!
//


//for i in 1...10{
//    i
//}
//
//let a = "01"
//
//Int(a)

//var a = "<p>1. asfs<br/>2. asf<br/>3. sa<br/>4. f<br/>5. sadf<br/>6. sa<br/>7. dfsdfjkljlksajf;<br/>8. sadf<br/>9. asdfsdf<br/>10. sadfsdf<br/>11. asdfsadfsa<br/>12. asdfsadfsda<br/>13. asdfsadfsdf</p>"
////a.stringByReplacingOccurrencesOfString("b", withString: "a")
//var stringTemp = NSString(string: a);
//
//let pattern = "((<p>\\d{1,2}. )(.)*</p>)";
////let pattern = "((<p>\\* )(.)*</p>)";
//
//var regex: NSRegularExpression?;
//do{
//    regex = try NSRegularExpression(pattern: pattern, options: [.AnchorsMatchLines])
//}catch{
//    let nserror = error as NSError
//    NSApplication.sharedApplication().presentError(nserror)
//}
//
//for textCheckingResult in regex!.matchesInString(stringTemp as String, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, stringTemp.length)){
//    stringTemp.substringWithRange(textCheckingResult.range);
//    var stringRange = textCheckingResult.range;
//    let stringTemp1 = stringTemp.stringByReplacingOccurrencesOfString("<p>\\d{1,2}. ", withString: "<ol><li>", options: [.RegularExpressionSearch],range: stringRange)
//    stringRange = NSMakeRange(stringRange.location, stringRange.length + stringTemp1.characters.count - stringTemp.length ) // 8-5
//    NSString(string: stringTemp1).substringWithRange(stringRange);
//    let stringTemp2 = NSString(string: stringTemp1).stringByReplacingOccurrencesOfString("<br/>\\d{1,2}. ", withString: "</li><li>", options: [.RegularExpressionSearch],range: stringRange)
//    stringRange = NSMakeRange(stringRange.location, stringRange.length + stringTemp2.characters.count - stringTemp1.characters.count  ) // 9-7
//    NSString(string: stringTemp2).substringWithRange(stringRange);
//    let stringTemp3 = NSString(string: stringTemp2).stringByReplacingOccurrencesOfString("</p>", withString: "</ol>", options: [.RegularExpressionSearch],range: stringRange)
//}
//
//var c = stringTemp.rangeOfString(pattern, options: [.RegularExpressionSearch]);
//c.length
//c.location
////stringTemp.substringWithRange(NSMakeRange(c.location, c.length));
//
//stringTemp = stringTemp.stringByReplacingOccurrencesOfString("<p>\\* ", withString: "<ul><li>", options: [.RegularExpressionSearch],range: NSMakeRange(0, stringTemp.length))
//stringTemp = stringTemp.stringByReplacingOccurrencesOfString("<br/>\\* ", withString: "</li><?", options: [.RegularExpressionSearch],range: NSMakeRange(0, stringTemp.length))
//


let a = "asdfsadfdsa\n* asdfasfsfdsfsafsfsaf\n* asdfsadfsdfsfsaf\n* sadsdfsafsafsf"
let pattern = "(^\\* )"

var regex: NSRegularExpression?;
do{
    regex = try NSRegularExpression(pattern: pattern, options: [.AnchorsMatchLines])
}catch{
    let nserror = error as NSError
    NSApplication.sharedApplication().presentError(nserror)
}

for textCheckingResult in regex!.matchesInString(a, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, a.characters.count)){
    NSString(string:a).substringWithRange(textCheckingResult.range);
}








