//
//  MarkdownRegexEnum.swift
//  MBase
//
//  Created by sunjie on 16/9/2.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

enum MarkdownRegexHeaderEnum: String {
    
    static let values4Edit = [H1,H2,H3,H4,H5,H6];

//    static let values = [H6,H5,H4,H3,H2,H1];
    static let values4Html = [H];
    
    case H = "(^(\\#{1,6} )((.)*))"
    
    case H1 = "(^(\\#{1} )((.)*))"
    case H2 = "(^(\\#{2} )((.)*))"
    case H3 = "(^(\\#{3} )((.)*))"
    case H4 = "(^(\\#{4} )((.)*))"
    case H5 = "(^(\\#{5} )((.)*))"
    case H6 = "(^(\\#{6} )((.)*))"
    
}
