//
//  DocEditViewController+MenuIBAction.swift
//  MBase
//
//  Created by sunjie on 16/8/30.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import MBaseMarkdown

extension DocEditViewController: NSTextViewDelegate {

    func textView(_ view: NSTextView, menu: NSMenu, for event: NSEvent, at charIndex: Int) -> NSMenu? {
        print("menu:"+menu.title)
        for menuItem in menu.items {
            if "字体" == menuItem.title{
                menuItem.isHidden = true;
            }
        }
        //添加item
        let menuItem_copyHtml = NSMenuItem(title: "复制HTML", action: #selector(DocEditViewController.copyHtml), keyEquivalent: "");
        menu.insertItem(menuItem_copyHtml, at: 0);
        
        //添加item
        let menuItem_test = NSMenuItem(title: "跳转", action: #selector(DocEditViewController.test), keyEquivalent: "");
        menu.insertItem(menuItem_test, at: 0);
        
        for item in menu.items {
            if item.title == "粘贴" || item.title == "替换" {
                menu.removeItem(item)
            }
        }
        return menu;
    }
    
    func copyHtml(_ menuItem: NSMenuItem) {
        let selectedText = self.docEditView.accessibilitySelectedText();
        if selectedText == ""{
            return;
        }
        let html = MarkdownManager.generateHTMLForMarkdown(selectedText!, cssType: .None);
        let pasteboard = NSPasteboard.general();
        pasteboard.clearContents();
        pasteboard.setString(html as! String, forType: NSPasteboardTypeString);
    }
    
    func test(_ menuItem: NSMenuItem) {
        self.setScroll();
    }
}
