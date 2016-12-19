//
//  DocumentViewControllerIBAction.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import Quartz

// MARK: - IBActions
extension DocumentViewController {
    
    @IBAction func bugTitleDidEndEdit(sender: AnyObject) {
        if let selectedDoc = selectedBugDoc() {
            selectedDoc.data.title = self.bugTitleView.stringValue;
            reloadSelectedBugRow();
        }
    }
    
    @IBAction func changePicture(sender: AnyObject) {
        if (selectedBugDoc() != nil) {
            IKPictureTaker().beginPictureTakerSheetForWindow(self.view.window, withDelegate: self, didEndSelector: #selector(DocumentViewController.pictureTakerDidEnd(_:returnCode:contextInfo:)), contextInfo: nil);
        }
    }
    
    func pictureTakerDidEnd(picker: IKPictureTaker, returnCode: NSInteger, contextInfo: UnsafePointer<Void>) {
        let image = picker.outputImage()
        if image != nil && returnCode == NSModalResponseOK {
            self.bugImageView.image = image;
            if let selectedDoc = selectedBugDoc() {
                selectedDoc.fullImage = image;
                selectedDoc.thumbImage = image.imageByScalingAndCroppingForSize(CGSize(width: 44, height: 44));
                reloadSelectedBugRow();
            }
        }
    }
    
    @IBAction func resetData(sender: AnyObject) {
        setupSampleBugs();
        updateDetailInfo(nil);
        bugsTableView.reloadData();
    }
    
    @IBAction func addBug(sender: AnyObject) {
        // 1. 使用默认值创建一个新的ScaryBugDoc实例
        let newDoc = ScaryBugDoc(title: "New Bug", rating: 0.0, thumbImage: nil, fullImage: nil);
        
        // 2. 将该实例添加到model 数组
        self.bugs.append(newDoc);
        
        let newRowIndex = self.bugs.count - 1;
        
        // 3.向table view插入新行
        self.bugsTableView.insertRowsAtIndexes(NSIndexSet(index: newRowIndex), withAnimation: NSTableViewAnimationOptions.EffectGap);
        
        // 4. 选中并滚动到新行
        self.bugsTableView.selectRowIndexes(NSIndexSet(index: newRowIndex), byExtendingSelection:false);
        self.bugsTableView.scrollRowToVisible(newRowIndex);
    }
    
    
    @IBAction func deleteBug(sender: AnyObject) {
        
        // 1. Get selected doc
        if (selectedBugDoc() != nil) {
            
            // 2. Remove the bug from the model
            let nowRow = self.bugsTableView.selectedRow;
            self.bugs.removeAtIndex(nowRow)
            
            // 3. Remove the selected row from the table view
            self.bugsTableView.removeRowsAtIndexes(NSIndexSet(index:self.bugsTableView.selectedRow),withAnimation: NSTableViewAnimationOptions.SlideRight);
            
            
            // 4. 清理model
            updateDetailInfo(nil);
            
            // 5. 选中下一行并滚动到新行
            var newSelectedRow = nowRow;
            if(self.bugsTableView.numberOfRows <= nowRow){
                newSelectedRow = self.bugsTableView.numberOfRows - 1;
            }
            self.bugsTableView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
            self.bugsTableView.scrollRowToVisible(newSelectedRow);
            
        }
    }
}
