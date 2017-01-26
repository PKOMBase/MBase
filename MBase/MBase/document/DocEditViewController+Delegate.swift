//
//  DocEditViewController+Delegate.swift
//  MBase
//
//  Created by sunjie on 16/8/7.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import MBaseMarkdown

extension DocEditViewController: NSTextStorageDelegate {
    
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int){
        if editedMask != .editedAttributes {
            self.editedRange = editedRange;
        }
    }
    
    func textDidBeginEditing(_ notification: Notification) {
        print("==textDidBeginEditing==");
    }
    
    func textDidChange(_ notification: Notification) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(changeTextFont), object: nil);
        self.perform(#selector(changeTextFont), with: nil, afterDelay: 0.3);
    }

    func changeTextFont(){
        let markdownEditManager = MarkdownEditManager(textStorage: self.docEditView.textStorage!);
        self.editedRange = NSMakeRange(0, self.docEditView.textStorage!.length);
        let content =  markdownEditManager.changeTextFont(self.docEditView.selectedRange(), editedRange: self.editedRange!);
        
        // 保存coredata
        self.docMainData.updateContent(content);
            
        self.docMainViewController.markdown = content;
        
        self.docMainViewController.refreshContent();

        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeDocImageAll"), object: nil);
    }
    
    func handlerInitFont(){
        let markdownEditManager = MarkdownEditManager(textStorage: self.docEditView.textStorage!);
        
        markdownEditManager.handlerInitFont();
    }
    
}
