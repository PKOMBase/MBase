//
//  MarkdownRegexListEnum.swift
//  MBase
//
//  Created by sunjie on 16/10/4.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

enum MarkdownRegexListEnum: String {
    
    static let values4Html = [NORMAL, ORDER, QUOTE];
    
    static let values4Edit = [NORMAL4EDIT, ORDER4EDIT, QUOTE4EDIT];
    
    case NORMAL = "(^(<p>\\* )(.)*</p>)"
    
    case ORDER = "(^(<p>\\d{1,2}. )(.)*</p>)"
    
    case QUOTE = "(^(<p>> )(.)*</p>)"
    
    case NORMAL4EDIT = "(^\\* )"
    
    case ORDER4EDIT = "(^\\d{1,2}. )"
    
    case QUOTE4EDIT = "(^> )"
    
}
