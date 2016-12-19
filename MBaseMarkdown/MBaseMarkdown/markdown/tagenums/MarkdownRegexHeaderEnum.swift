//
//  MarkdownRegexEnum.swift
//  MBase
//
//  Created by sunjie on 16/9/2.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

enum MarkdownRegexHeaderEnum: String {
    
    static let values = [H6,H5,H4,H3,H2,H1];

    case H1 = "(^(\\#{1} )((.)*))"
    case H2 = "(^(\\#{2} )((.)*))"
    case H3 = "(^(\\#{3} )((.)*)$)"
    case H4 = "(^(\\#{4} )((.)*)$)"
    case H5 = "(^(\\#{5} )((.)*)$)"
    case H6 = "(^(\\#{6} )((.)*)$)"
    
}
