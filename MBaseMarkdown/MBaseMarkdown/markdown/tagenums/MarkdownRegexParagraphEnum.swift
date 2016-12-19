//
//  MarkdownRegexParagraphEnum.swift
//  MBase
//
//  Created by sunjie on 16/9/2.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

enum MarkdownRegexParagraphEnum: String {
    
    static let values = [CODE1, CODE2];
    
    case CODE1 = "(`{3}(.)*?`{3})"
    
    case CODE2 = "(`{1}(.)*?`{1})"
    
    var codeKey: String {
        switch self {
        case .CODE1:
            return "```"
        case .CODE2:
            return "`"
        }
    }
}
