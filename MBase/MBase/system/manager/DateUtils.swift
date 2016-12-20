//
//  DateUtils.swift
//  MBase
//
//  Created by sunjie on 16/9/2.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DateUtils: NSObject {

    static func getStartOfCurrentMonth() -> Date{
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    
    static func getEndOfCurrentMonth() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = 1
        components.day = -1
        return (calendar as NSCalendar).date(byAdding: components, to: self.getStartOfCurrentMonth(), options: [])!

    }
    
    
    static func getAddDays(_ date: Date, days: Int) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = days
        return (calendar as NSCalendar).date(byAdding: components, to: date, options: [])!
    }

}
