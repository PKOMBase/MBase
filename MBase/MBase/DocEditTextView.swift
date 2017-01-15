//
//  DocEditTextView.swift
//  MBase
//
//  Created by sunjie on 2017/1/15.
//  Copyright © 2017年 popkidorc. All rights reserved.
//

import Cocoa

class DocEditTextView: NSTextView {

    var docEditViewController : DocEditViewController? = nil;
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect);
    }
    
    override func paste(_ sender: Any?) {
        if self.docEditViewController == nil{
            return;
        }
        self.docEditViewController!.pasteAction();
    }
    
}
