//
//  ExportUtils.swift
//  MBase
//
//  Created by sunjie on 16/9/15.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import MBaseMarkdown

class ExportUtils: NSObject {
        
    static func exportFiles(_ manager: FileManager, docTree: DocTree, exportPath: String, type: String = "html") throws {
        var path = exportPath;
        path += "/" + docTree.name!;
        if docTree.children!.count <= 0 {
            var content:NSString = "";
            if type == "html"{
                content = MarkdownManager.generateHTMLForMarkdown(docTree.docMain!.content! , cssType: .Default);
            } else {
                content = docTree.docMain!.content! as NSString;
            }
            let contentData = content.data(using: String.Encoding.unicode.rawValue);
            manager.createFile(atPath: path + "." + type, contents: contentData, attributes: [:]);
        }else {
            // 先建目录
            try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: [:]);
            // 如果内容不为空则创建文章
            if docTree.docMain!.content != "" {
                var content:NSString = "";
                if type == "html" {
                    content = MarkdownManager.generateHTMLForMarkdown(docTree.docMain!.content! , cssType: .Default);
                } else {
                    content = docTree.docMain!.content! as NSString;
                }
                let contentData = content.data(using: String.Encoding.unicode.rawValue);
                manager.createFile(atPath: path + "." + type, contents: contentData, attributes: [:]);
            }
            // 子目录
            for child in docTree.children! {
                try self.exportFiles(manager, docTree: child as! DocTree, exportPath: path, type: type);
            }
        }
    }
}
