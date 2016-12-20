//
//  MarkdownHtmlTagParagraph.swift
//  MBase
//
//  Created by sunjie on 16/9/2.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTagParagraph: MarkdownHtmlTag {

    override func getHtml(_ index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        var str = self.string;
        for tag in self.markdownTag {
            str = str.replacingOccurrences(of: tag, with: "")
        }
        str = str.replacingOccurrences(of: "<p>", with: "")
        str = str.replacingOccurrences(of: "</p>", with: "")
        str = str.replacingOccurrences(of: "<br/>", with: "\n")
        str = str.replacingOccurrences(of: "<li>", with: "");
        str = str.replacingOccurrences(of: "</li>", with: "");
        str = str.replacingOccurrences(of: "<ol>", with: "");
        str = str.replacingOccurrences(of: "</ol>", with: "");
        str = str.replacingOccurrences(of: "<ul>", with: "");
        str = str.replacingOccurrences(of: "</ul>", with: "");
        return self.getHtml4Prefix() + self.handlerTransferString(str) + self.getHtml4Suffix()
    }
    
}
