//
//  DateUtils.swift
//  MBase
//
//  Created by sunjie on 16/9/2.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DateUtils: NSObject {

    static func getStartOfCurrentMonth() -> NSDate{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month], fromDate: date)
        return calendar.dateFromComponents(components)!
    }
    
    
    static func getEndOfCurrentMonth() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.month = 1
        components.day = -1
        return calendar.dateByAddingComponents(components, toDate: self.getStartOfCurrentMonth(), options: [])!

    }
    
    
    static func getAddDays(date: NSDate, days: Int) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.day = days
        return calendar.dateByAddingComponents(components, toDate: date, options: [])!
    }

}
