//
//  DocTreeViewController+MenuIBAction.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

extension DocTreeViewController: NSMenuDelegate {
    
    func menuWillOpen(menu: NSMenu) {
        let selectedDocTree = self.selectedTree();
        var docTreeType: DocTree.DocTreeType;
        for menuItem in menu.itemArray {
            if selectedDocTree == nil {
                menuItem.hidden = true;
                continue;
            }
            docTreeType = DocTree.DocTreeType(rawValue: selectedDocTree!.type!)!;
            
            if docTreeType.menuItemTags().contains(menuItem.tag) {
                menuItem.hidden = false;
            } else {
                menuItem.hidden = true;
            }
        }
    }
    
    @IBAction func addTree(sender: AnyObject) {
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        let parentDocTree = managedObjectContext.objectWithID(selectedDocTree!.parent!.objectID) as! DocTree;
        
        // 1. 创建Tree
        let newDocTree = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        let newDocMain = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
        newDocMain.initData("", summary: "", mark: "", type: DocMain.DocMainType.Markdown, docTree: newDocTree);
        newDocTree.initData("new",content: "", image: NSImage(named: "GenericFolderIcon"), type: DocTree.DocTreeType.Normal,  parent: parentDocTree, docMain: newDocMain);
        
        // 2. 将该实例添加到父级Tree
        parentDocTree.addChildTree(newDocTree);
        
        // 3. 重载数据
        self.reloadData();
        
        // 4. 选中并滚动到新行
        let newSelectedRow = self.docTreeView.rowForItem(newDocTree);
        self.docTreeView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
        self.docTreeView.scrollRowToVisible(newSelectedRow);
    }
    
    @IBAction func addChildTree(sender: AnyObject) {
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        // 1. 创建Tree
        let newDocTree = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        let newDocMain = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
        newDocMain.initData("", summary: "", mark: "", type: DocMain.DocMainType.Markdown, docTree: newDocTree);
        newDocTree.initData("new", content: "", image: NSImage(named: "GenericFolderIcon"), type: DocTree.DocTreeType.Normal,  parent: selectedDocTree!, docMain: newDocMain);
        
        // 2. 将该实例添加到选中Tree
        selectedDocTree!.addChildTree(newDocTree);
        
        // 3. 重载数据
        self.reloadData();
        
        // 4. 展开选中节点
        self.docTreeView.expandItem(selectedDocTree);
        
        // 5. 选中并滚动到新行
        let newSelectedRow = self.docTreeView.rowForItem(newDocTree);
        self.docTreeView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
        self.docTreeView.scrollRowToVisible(newSelectedRow);
        
        self.changeDocImage(selectedDocTree!)
    }
    
    @IBAction func createDiary(sender: AnyObject) {
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        
        let newSelectedTree = self.createDiaryTree(selectedDocTree!);
        
        // 5. 选中并滚动到新行
        let newSelectedRow = self.docTreeView.rowForItem(newSelectedTree);
        self.docTreeView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
        self.docTreeView.scrollRowToVisible(newSelectedRow);
        
    }
    
    @IBAction func removeTree(sender: AnyObject) {
        // 1. 获取选中tree
        let selectedDocTree = self.selectedTree();
        if (selectedDocTree == nil) {
            return;
        }
        // 2. 移动到回收站
        var trashTree: DocTree?;
        for docTree in docTreeData.children! {
            if DocTree.DocTreeType.Trash.rawValue == (docTree as! DocTree).type {
                trashTree = docTree as? DocTree;
            }
        }
        if trashTree == nil {
            return;
        }
        let parent = selectedDocTree!.parent;
        self.moveNode(selectedDocTree!, targetParentDocTree: trashTree!, targetIndex: nil);
        
        self.changeDocImage(parent!)
        // 3. 重载数据
        self.reloadData();
        
        // 4. 清除eidt、view
        self.docEditViewController.cleanDocEditDatas();
    }
    
    @IBAction func cleanTrash(sender: AnyObject) {
        // 1. 获取选中tree
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil || DocTree.DocTreeType.Trash.rawValue != selectedDocTree?.type{
            return;
        }
        
        // 2. model中移除数据,以及对应文档数据
        if selectedDocTree!.children == nil || selectedDocTree!.children?.count <= 0{
            return;
        }
        selectedDocTree!.removeAllChild();
        
        // 3. 重载数据
        self.reloadData();
    }
    
    @IBAction func exportHTML(sender: AnyObject) {
        if self.selectedTree() == nil{
            return;
        }
        self.export("html");
    }
    
    @IBAction func exportText(sender: AnyObject) {
        if self.selectedTree() == nil{
            return;
        }
        self.export("txt");
    }
    
    func export(type: String){
        let selectedTree = self.selectedTree()!;
        // 文章还是文件夹
        let panel = NSSavePanel();
        panel.canCreateDirectories = true;
        // 如果是文章
        if selectedTree.children!.count <= 0 {
            panel.nameFieldStringValue = selectedTree.name!;
            panel.allowedFileTypes = [type];
            panel.allowsOtherFileTypes = false;
            panel.extensionHidden = true;
        }
            // 如果是目录
        else {
            panel.nameFieldStringValue = "MBase文件";
            panel.allowsOtherFileTypes = false;
            panel.extensionHidden = true;
        }
        if panel.runModal() == NSFileHandlingPanelOKButton {
            let manager = NSFileManager.defaultManager();
            let path = panel.URL!.path!;
            do {
                if selectedTree.children!.count > 0{
                    // 先建目录
                    try manager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: [:]);
                }
                try ExportUtils.exportFiles(manager, docTree: selectedTree, exportPath: path, type: type);
            } catch{
                let nserror = error as NSError;
                NSApplication.sharedApplication().presentError(nserror);
            }
        }
    }
    
}
