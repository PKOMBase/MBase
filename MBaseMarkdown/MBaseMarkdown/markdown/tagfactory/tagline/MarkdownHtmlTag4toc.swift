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
    
    func getHtml(_ index: Int, allString: String, object: Dictionary<MarkdownRegexCommonEnum,[Dictionary<String, AnyObject>]>) -> String!{
        if string == ""{
            return super.getHtml(index, object: object);
        }
        var objectDic = object[MarkdownRegexCommonEnum.HEADER];
        if nil == objectDic || 0 == objectDic?.count || nil == objectDic?[0]["TOC"]{
            return super.getHtml(index, object: object);
        }
        var rootTree = objectDic?[0]["TOC"] as! Tree;
        return rootTree.toString();
    }
    
}


class Tree{
    var id = 0;
    
    var level = 0;
    
    var name = "";
    
    var parent: Tree?;
    
    var children: [Tree]?;
    
    init(id: Int, level: Int, name: String){
        self.id = id;
        self.level = level;
        self.name = name;
    }
    
    func addChild(tree: Tree){
        if nil == self.children {
            self.children = [Tree]();
        }
        // 若是该节点的level是需要添加节点level的父，则直接添加
        if self.level + 1 == tree.level {
            tree.parent = self;
            self.children?.append(tree);
        }
        // 若是该节点的level不是需要添加节点level的父，则先递归创建，直到创建新节点的level是需要添加节点level的父，再进行添加
        else {
            var nextTree = Tree(id: 0, level: self.level + 1, name: "");
            nextTree.parent = self;
            nextTree.addChild(tree: tree);
            self.children?.append(nextTree);
        }
    }
    
    func addParentChild(tree: Tree) {
        if nil == self.children {
            self.children = [Tree]();
        }
        if nil == self.parent {
            return;
        }
        // 若是该节点的level是需要添加节点level的父，则调用添加节点方法
        if self.parent!.level + 1 == tree.level {
            self.parent!.addChild(tree: tree);
        }
        // 若是该节点的level不是需要添加节点level的父，则递归，直到创建新节点的level是需要添加节点level的父，再进行添加
        else {
            self.parent!.addParentChild(tree: tree);
        }
    }

    
    func getLI() -> String{
        return "<li><a href=\"#h"+String(self.level)+"_"+String(self.id)+"\">"+self.name.replacingOccurrences(of: "<", with: "&lt;").replacingOccurrences(of: ">", with: "&gt;")+"</a></li>";
    }
    
//    func printTree(){
//        var header = "";
//        for i in 0...level {
//            header = header+" ";
//        }
//        if level > 0 {
//            print("<ul>");
//            print(header+String(self.getLI()));
//        }
//        if nil == self.children {
//            return;
//        }
//        for child in self.children!{
//            child.printTree();
//        }
//        if level > 0 {
//            print("</ul>");
//        }
//    }
    
    func toString() -> String{
        var string = "";
        if level > 0 {
            string += "<ul>";
            string += String(self.getLI());
        }
        if nil != self.children {
            for child in self.children!{
                string += child.toString();
            }
        }
        if level > 0 {
            string += "</ul>";
        }
        return string;
    }
    
}
