//
//  DocTreeViewController+Delegate.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocTreeViewController: NSOutlineViewDelegate {
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        
        //获取并展示docmain
        self.docEditViewController.initDocEditDatas(selectedDocTree!.docMain);

        // 记录用户操作
        self.userInfo.updateSelectedDocTree(selectedDocTree!);
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeDocImageAll"), object: nil);

    }
    
}
