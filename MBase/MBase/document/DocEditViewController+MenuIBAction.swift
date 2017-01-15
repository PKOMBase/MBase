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
    
    func pasteAction() {
        let pasteboard = NSPasteboard.general();
        if pasteboard.changeCount <= 0 {
            return;
        }
        let normalAttributes = [NSParagraphStyleAttributeName : MarkdownConstsManager.getDefaultParagraphStyle(), NSFontAttributeName : NSFont.systemFont(ofSize: MarkdownConstsManager.defaultFontSize), NSForegroundColorAttributeName : MarkdownConstsManager.defaultFontColor];
        let mutableAttributedString = NSMutableAttributedString();
//        var resultRange: NSRange? = nil;
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
            mutableAttributedString.append(NSAttributedString(string: "![]("+path+")\n", attributes: normalAttributes));
            
            //展示图片
            let image = NSImage(data: data!);
            let textAttachment = NSTextAttachment();
            let attachmentCell = NSTextAttachmentCell(imageCell: image);
            textAttachment.attachmentCell = attachmentCell;
            mutableAttributedString.append(NSAttributedString(attachment: textAttachment));
            mutableAttributedString.append(NSAttributedString(string: "\n", attributes: normalAttributes));
        } else {
            print("==NSPasteboardTypeOTHER=")
            let string = pasteboard.string(forType: NSPasteboardTypeString);
            if string == nil{
                return;
            }
            mutableAttributedString.append(NSAttributedString(string: string!, attributes: normalAttributes));
        }
        self.pasteText(range: self.docEditView.selectedRange(), mutableAttributedString: mutableAttributedString);
    }
    
    func pasteText(range: NSRange, mutableAttributedString: NSAttributedString) {
        self.docEditView.textStorage!.replaceCharacters(in: range, with: mutableAttributedString);
        let resultRange = NSMakeRange(self.docEditView.selectedRange().location, mutableAttributedString.length);
        self.registerPasteUndo(range: resultRange, mutableAttributedString: mutableAttributedString);
    }
    
    func removeText(range: Any) {
        print("==removeText=="+String((range as! NSRange).location));
        self.docEditView.textStorage!.deleteCharacters(in: (range as! NSRange));
    }
    
    func registerPasteUndo(range: NSRange, mutableAttributedString: NSAttributedString){
        print("==re undo=="+String(range.location)+"==="+String(range.length))
        self.docEditView.undoManager?.registerUndo(withTarget: self, selector: #selector(DocEditViewController.removeText(range:)), object: range);
    }
    
    func registerPasteRedo(range: NSRange, mutableAttributedString: NSAttributedString) {
        print("==re redo==")
        self.docEditView.undoManager?.registerUndo(withTarget: self, selector: #selector(DocEditViewController.pasteText(range:mutableAttributedString:)), object: range);
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
