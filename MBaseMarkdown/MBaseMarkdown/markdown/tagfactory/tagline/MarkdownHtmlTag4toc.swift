//
//  MarkdownHtmlTag4img2.swift
//  MBase
//
//  Created by sunjie on 16/8/13.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MarkdownHtmlTag4toc: MarkdownHtmlTagLine {
    
    override init(range: NSRange, string: String){
        super.init(range: range, string: string);
        super.tagName = "ul";
        super.markdownTag = ["[TOC]"];
    }
    
    override func getHtml(index: Int, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        if string == ""{
            return super.getHtml(index, object: object);
        }
        var result = string;
        do{
            let headerParams = object[.HEADER];
            
            var trees = [Tree]();
            
            for object in headerParams! {
                for key in object.keys {
                    let value = object[key] as! MarkdownHtmlTagHeader;
                    print("==header=="+key+"===="+value.getString()+"==="+value.tagName );
//                    let level = value.tagName.r
//                    if "h1" == value.tagName{
//                        let tree = Tree(id: value.tagName, name: value.getString());
//                        trees.append(tree);
//                    }
//                    if "h2" == value.tagName{
//                        if trees.count > 0 && trees{
//                            
//                        }
//                    }
                    
                }
            }
            
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        return super.getHtml(index, object: object);
    }
    
    
    func getUL(id: String, name: String) -> String{
        
        return "<ul>";
    }
    
    
    func getLI(id: String, name: String) -> String{
        return "<li><a href=\"#"+id+"\">"+name+"</a></li>";
    }
    
}


class Tree{
    var id = "";
    
    var level = 0;
    
    var name = "";
    
    var childs = [Tree]();
    
    init(id: String, level: Int, name: String){
        self.id = id;
        self.level = level;
        self.name = name;
    }
}