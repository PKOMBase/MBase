//
//  DocTreeViewController+DataSource.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocTreeViewController: NSOutlineViewDataSource {
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if (item != nil)
        {
            let docTreeData = item as! DocTree;
            return docTreeData.children!.count;
        }
        if docTreeData != nil {
            //不显示根
            return docTreeData.children!.count;
        } else {
            return 0;
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        let docTreeData = item as! DocTree;
        if docTreeData.children == nil || docTreeData.children?.count <= 0 {
            return false;
        } else {
            return true;
        }
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if (item != nil)
        {
            let docTreeData = item as! DocTree;
            if docTreeData.children != nil {
                return docTreeData.children![index];
            }
        }
        //不显示根
        return docTreeData.children![index];
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        let cellView = outlineView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView;
        if tableColumn!.identifier == "DocTreeColumn" {
            let docTreeData = item as! DocTree;
            cellView.objectValue = docTreeData.objectID;
            cellView.textField?.stringValue = docTreeData.name!;
            if docTreeData.image != nil {
                cellView.imageView?.image = NSImage(data: docTreeData.image!);
            }
        }
        return cellView;
    }
    
    func outlineView(outlineView: NSOutlineView, pasteboardWriterForItem item: AnyObject) -> NSPasteboardWriting? {
        let pbItem = NSPasteboardItem();
        if let docTree = item as? DocTree {
            if DocTree.DocTreeType.Trash.rawValue == docTree.type {
                return nil
            }
            pbItem.setString(docTree.name, forType: NSPasteboardTypeString);
            return pbItem;
        }
        return nil
    }
    
    func outlineView(outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: AnyObject?, proposedChildIndex index: Int) -> NSDragOperation {
        if index >= 0 {
            return NSDragOperation.Move;
        }else{
            return NSDragOperation.None;
        }
    }
    
    func outlineView(outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: AnyObject?, childIndex index: Int) -> Bool {
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return false;
        }
        //        let pd = info.draggingPasteboard();
        //        let name = pd.stringForType(NSPasteboardTypeString);
        
        let parentDocTree: DocTree;
        if item == nil {
            parentDocTree = self.docTreeData;
        } else {
            parentDocTree = item as! DocTree;
        }
        
        if DocTree.DocTreeType.Root.rawValue == parentDocTree.type && index == 0 {
            return false;
        }
        
        self.moveNode(selectedDocTree!, targetParentDocTree: parentDocTree, targetIndex: index);
        return true
    }
    
}
