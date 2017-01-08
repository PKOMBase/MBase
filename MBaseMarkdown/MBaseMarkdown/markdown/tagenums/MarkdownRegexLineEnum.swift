//
//  MarkdownRegexEnum.swift
//  MBase
//
//  Created by sunjie on 16/9/2.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

enum MarkdownRegexLineEnum: String {
    
    static let values = [STRONG,EM,U,DEL,IMG1,IMG2,A1,A2,A3,A4,FOOTREL,HR,TOC];
    
    case HR = "((- - -)|(\\*\\*\\*\\*\\*)|(\\*\\*\\*))"
    
    case EM = "(\\*(.)*\\*)"
    case STRONG = "((\\*\\*(.)*\\*\\*)|(\\_\\_(.)*\\_\\_))"
    case U = "(_(.)*_)"
    case DEL = "(~~(.)*~~)"
        
    case A1 = "(\\[(.)*\\]\\((.)*\\))"
    case A2 = "(\\[(.)*\\]\\[\\d{1,2}\\])"
    case A3 = "(\\<(http|https)://(.(?!<))*\\>)"
    case A4 = "(\\<((?!>).)*@(.(?!<))*\\>)"
    
    case IMG1 = "(\\!\\[(.)*\\]\\((.)*\\))"
    case IMG2 = "(\\!\\[(.)*\\]\\[\\d{1,2}\\])"
    
    case FOOTREL = "(\\[\\^(.)*\\])"
    
    case TOC = "(\\[TOC\\])"
    
}
