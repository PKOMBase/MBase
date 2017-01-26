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
    
    class PasteObject {
    
        var newRange: NSRange?
        
        var newMutableAttributedString: NSAttributedString?
        
        var oldRange: NSRange?
        
        var oldMutableAttributedString: NSAttributedString?
        
        var nowTree: DocTree?
        
        init(newRange: NSRange, newMutableAttributedString: NSAttributedString, oldRange: NSRange, oldMutableAttributedString: NSAttributedString, nowTree: DocTree){
            self.newRange = newRange;
            self.newMutableAttributedString = newMutableAttributedString;
            self.oldRange = oldRange;
            self.oldMutableAttributedString = oldMutableAttributedString;
            self.nowTree = nowTree;
        }
        
    }
    
    func textView(_ view: NSTextView, menu: NSMenu, for event: NSEvent, at charIndex: Int) -> NSMenu? {
        var pasteIndex = 0;
        for item in menu.items {
            if item.title == "粘贴"{
                pasteIndex = menu.index(of: item);
                menu.removeItem(item);
            }
            if item.title == "字体" || item.title == "替换" {
                menu.removeItem(item);
            }
           
        }
        //添加item
        menu.insertItem(withTitle: "复制HTML", action:  #selector(DocEditViewController.copyHtml), keyEquivalent: "", at: 0);
        
        //添加粘贴item
        menu.insertItem(withTitle: "粘贴", action:  #selector(DocEditViewController.pasteAction), keyEquivalent: "v", at: pasteIndex);
        
        //添加测试item
        menu.insertItem(withTitle: "测试", action: #selector(DocEditViewController.test), keyEquivalent: "m", at: 0);
       
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
    
    func pasteAction(_ menuItem: NSMenuItem) {
        let pasteboard = NSPasteboard.general();
        if pasteboard.changeCount <= 0 {
            return;
        }
        let normalAttributes = [NSParagraphStyleAttributeName : MarkdownConstsManager.getDefaultParagraphStyle(), NSFontAttributeName : NSFont.systemFont(ofSize: MarkdownConstsManager.defaultFontSize), NSForegroundColorAttributeName : MarkdownConstsManager.defaultFontColor];
        let mutableAttributedString = NSMutableAttributedString();
        if pasteboard.canReadItem(withDataConformingToTypes: [NSPasteboardTypeTIFF, NSPasteboardTypePNG]){
            print("==NSPasteboardTypePNG=")
            let data = pasteboard.data(forType: NSPasteboardTypeTIFF);
            if data == nil{
                return;
            }
            if docMainData.docTree == nil{
                return;
            }
            
            //将图片存至黑盒文件夹
            let manager = FileManager.default;
            var path = "image/"+docMainData.docTree!.name!;
            
            // 先建目录
            do {
                try manager.createDirectory(atPath: Bundle.main.resourcePath!+"/"+path, withIntermediateDirectories: true, attributes: [:]);
            } catch{
                let nserror = error as NSError;
                NSApplication.shared().presentError(nserror);
            }
            
            // 存文件
            path = path+"/"+UUID().uuidString+".png";
            print("==image path=="+path);
            manager.createFile(atPath: Bundle.main.resourcePath!+"/"+path, contents: data!, attributes: [:]);
            
            mutableAttributedString.append(NSAttributedString(string: "\n![]("+path+")", attributes: normalAttributes));
        } else {
            print("==NSPasteboardTypeOTHER=")
            let string = pasteboard.string(forType: NSPasteboardTypeString);
            if string == nil{
                return;
            }
            mutableAttributedString.append(NSAttributedString(string: string!, attributes: normalAttributes));
        }
        let pasteObject = PasteObject(newRange: NSMakeRange(self.docEditView.selectedRange().location, mutableAttributedString.length), newMutableAttributedString: mutableAttributedString, oldRange: self.docEditView.selectedRange(), oldMutableAttributedString: self.docEditView.textStorage!.attributedSubstring(from: self.docEditView.selectedRange()), nowTree: self.docMainData.docTree!);
        self.pasteText(paste: pasteObject);
    }
    
    func pasteText(paste: Any) {
        let pasteObject = paste as! PasteObject;
        //判断是否同一tree
        if self.docMainData.docTree != pasteObject.nowTree{
            return;
        }
        self.docEditView.textStorage!.replaceCharacters(in: pasteObject.oldRange!, with: pasteObject.newMutableAttributedString!);
        //光标跳转
        self.docEditView.setSelectedRange(NSMakeRange(pasteObject.oldRange!.location+pasteObject.newMutableAttributedString!.length, 0));
        // 刷新样式
        self.changeTextFont();
        
        // 需要undo的pasteObject
        let pasteObjectUndo = PasteObject(newRange: pasteObject.oldRange!, newMutableAttributedString: pasteObject.oldMutableAttributedString!, oldRange: pasteObject.newRange!, oldMutableAttributedString: pasteObject.newMutableAttributedString!, nowTree: self.docMainData.docTree!);
        self.registerPasteUndo(paste: pasteObjectUndo);
    }
    
    func removeText(paste: Any) {
        let pasteObject = paste as! PasteObject;
        //判断是否同一tree
        if self.docMainData.docTree != pasteObject.nowTree{
            return;
        }
        self.docEditView.textStorage!.deleteCharacters(in: pasteObject.oldRange!);
        //光标跳转
        self.docEditView.setSelectedRange(NSMakeRange(pasteObject.oldRange!.location, 0));
        // 刷新样式
        self.changeTextFont();
        
        // 需要redo的pasteObject
        let pasteObjectUndo = PasteObject(newRange: pasteObject.oldRange!, newMutableAttributedString: pasteObject.oldMutableAttributedString!, oldRange: pasteObject.newRange!, oldMutableAttributedString: pasteObject.newMutableAttributedString!, nowTree: self.docMainData.docTree!);
        self.registerPasteRedo(paste: pasteObjectUndo);
    }
    
    func registerPasteUndo(paste: PasteObject){
        //判断是否同一tree
        if self.docMainData.docTree != paste.nowTree{
            return;
        }
        self.docEditView.undoManager?.registerUndo(withTarget: self, selector: #selector(DocEditViewController.removeText(paste:)), object: paste);
    }
    
    func registerPasteRedo(paste: PasteObject) {
        //判断是否同一tree
        if self.docMainData.docTree != paste.nowTree{
            return;
        }
        self.docEditView.undoManager?.registerUndo(withTarget: self, selector: #selector(DocEditViewController.pasteText(paste:)), object: paste);
    }
    
    func test(_ menuItem: NSMenuItem) {
        //        self.setScroll();
        
        let pasteboard = NSPasteboard.general();
        if pasteboard.canReadItem(withDataConformingToTypes: [NSPasteboardTypeTIFF, NSPasteboardTypePNG]){
            print("==NSPasteboardTypePNG=")
            let data = pasteboard.data(forType: NSPasteboardTypeTIFF);
            if data == nil{
                return;
            }
            if docMainData.docTree == nil{
                return;
            }
            
            //将图片存至黑盒文件夹
            let manager = FileManager.default;
            var path = "/image/"+docMainData.docTree!.name!;
            
            // 先建目录
            do {
                try manager.createDirectory(atPath: Bundle.main.resourcePath!+path, withIntermediateDirectories: true, attributes: [:]);
            } catch{
                let nserror = error as NSError;
                NSApplication.shared().presentError(nserror);
            }
            
            // 存文件
            path = path+"/"+UUID().uuidString+".png";
            print("==image path=="+path);
            manager.createFile(atPath: Bundle.main.resourcePath!+path, contents: data!, attributes: [:]);
            let normalAttributes = [NSParagraphStyleAttributeName : MarkdownConstsManager.getDefaultParagraphStyle(), NSFontAttributeName : NSFont.systemFont(ofSize: MarkdownConstsManager.defaultFontSize), NSForegroundColorAttributeName : MarkdownConstsManager.defaultFontColor];
            
            self.docEditView.textStorage!.insert(NSAttributedString(string: "![]("+path+")\n", attributes: normalAttributes) , at: 0);
            
            //展示图片
            let image = NSImage(data: data!);
            print("==image=="+String(describing: image!.size.width));
            let textAttachment = NSTextAttachment();
            let attachmentCell = NSTextAttachmentCell(imageCell: image);
            textAttachment.attachmentCell = attachmentCell;
            self.docEditView.textStorage!.insert(NSAttributedString(attachment: textAttachment), at: 50);
            
        }
    
    }
}


