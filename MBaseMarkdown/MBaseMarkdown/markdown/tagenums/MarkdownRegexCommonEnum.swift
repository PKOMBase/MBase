//
//  MarkdownRegexCommonEnum.swift
//  MBase
//
//  Created by sunjie on 16/9/2.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

enum MarkdownRegexCommonEnum: String {

    static let values = [URL,FOOT];
    
    case URL = "(^\\[\\d{1,2}\\]:(.)*$)"
    
    case FOOT = "(\\[\\^(.)*\\]:(.)*)"
    
    //虚拟，不加入values
    
    case HEADER = "HEADER"
    
  
}
