//
//  DocTreeInfoViewController+IBAction.swift
//  MBase
//
//  Created by sunjie on 16/7/23.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import Quartz

extension DocTreeInfoViewController {
    
    @IBAction func changPicture(_ sender: AnyObject) {
        if docTreeInfoData != nil {
            IKPictureTaker().beginSheet(for: self.view.window!.parent!, withDelegate: self, didEnd: #selector(DocTreeInfoViewController.pictureTakerDidEnd(_:returnCode:contextInfo:)), contextInfo: nil);
        }
    }
    
    func pictureTakerDidEnd(_ picker: IKPictureTaker, returnCode: NSInteger, contextInfo: UnsafeRawPointer) {
        let image = picker.outputImage()
        if image != nil && returnCode == NSModalResponseOK {
            self.docTreeInfoData?.image = image;
            self.docTreeInfoData?.isChangeImage = true;
            self.docTreeViewController?.changeSelectedData(docTreeInfoData, selectedDocTree: self.docTreeData);
        }
    }
    
}
