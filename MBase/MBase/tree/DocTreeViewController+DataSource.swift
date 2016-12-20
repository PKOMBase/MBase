//
//  DocTreeViewController+DataSource.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


extension DocTreeViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
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
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let docTreeData = item as! DocTree;
        if docTreeData.children == nil || docTreeData.children?.count <= 0 {
            return false;
        } else {
            return true;
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
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
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let cellView = outlineView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView;
        if tableColumn!.identifier == "DocTreeColumn" {
            let docTreeData = item as! DocTree;
            cellView.objectValue = docTreeData.objectID;
            cellView.textField?.stringValue = docTreeData.name!;
            if docTreeData.image != nil {
                cellView.imageView?.image = NSImage(data: docTreeData.image! as Data);
            }
        }
        return cellView;
    }
    
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
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
    
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        if index >= 0 {
            return NSDragOperation.move;
        }else{
            return NSDragOperation();
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
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
