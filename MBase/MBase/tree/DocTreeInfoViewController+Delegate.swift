//
//  DocTreeInfoViewController+Delegate.swift
//  MBase
//
//  Created by sunjie on 16/7/23.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocTreeInfoViewController: NSPopoverDelegate {

    func popoverDidClose(notification: NSNotification) {

        self.docTreeInfoData?.name = self.nameField.stringValue;
        self.docTreeInfoData?.content = self.contentField.string;
        self.docTreeInfoData?.image = self.imageView.image;
        self.docTreeInfoData?.isChangeImage = false;
        self.docTreeViewController!.changeSelectedData(self.docTreeInfoData, selectedDocTree: self.docTreeData);
    }

}
