//
//  MarkdownRegexListEnum.swift
//  MBase
//
//  Created by sunjie on 16/10/4.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

enum MarkdownRegexListEnum: String {
    
    static let values = [NORMAL, ORDER, QUOTE];
    
    case NORMAL = "(^\\* )"
    
    case ORDER = "(^\\d{1,2}. )"
    
    case QUOTE = "(^> )"
    
    var codeKey: String {
        switch self {
        case .NORMAL:
            return "*"
        case .ORDER:
            return ""
        case .QUOTE:
            return ">"
        }
    }
}
