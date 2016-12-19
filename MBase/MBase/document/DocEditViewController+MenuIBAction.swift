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

    func textView(view: NSTextView, menu: NSMenu, forEvent event: NSEvent, atIndex charIndex: Int) -> NSMenu? {
        print("menu:"+menu.title)
        for menuItem in menu.itemArray {
            if "字体" == menuItem.title{
                menuItem.hidden = true;
            }
        }
        //添加item
        let menuItem_copyHtml = NSMenuItem(title: "复制HTML", action: #selector(DocEditViewController.copyHtml), keyEquivalent: "");
        menu.insertItem(menuItem_copyHtml, atIndex: 0);
        
        //添加item
        let menuItem_test = NSMenuItem(title: "跳转", action: #selector(DocEditViewController.test), keyEquivalent: "");
        menu.insertItem(menuItem_test, atIndex: 0);
        
        for item in menu.itemArray {
            if item.title == "粘贴" || item.title == "替换" {
                menu.removeItem(item)
            }
        }
        return menu;
    }
    
    func copyHtml(menuItem: NSMenuItem) {
        let selectedText = self.docEditView.accessibilitySelectedText();
        if selectedText == ""{
            return;
        }
        let html = MarkdownManager.generateHTMLForMarkdown(selectedText!, cssType: .None);
        let pasteboard = NSPasteboard.generalPasteboard();
        pasteboard.clearContents();
        pasteboard.setString(html as String, forType: NSPasteboardTypeString);
    }
    
    func test(menuItem: NSMenuItem) {
        self.setScroll();
    }
}
