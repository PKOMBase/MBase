//
//  AppDelegateIBAction.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

// MARK: - IBActions
extension AppDelegate: NSMenuDelegate {
    
    @IBAction func paste(_ sender: Any) {
        let menu = sender as! NSMenuItem;
        if self.mainWindowController.mainSplitViewController!.docSplitViewController.docEditViewController.becomeFirstResponder(){
            self.mainWindowController.mainSplitViewController!.docSplitViewController.docEditViewController.pasteAction(menu);
        }
    }
    
    @IBAction func fileNew(_ sender: Any) {
        if (!self.mainWindowController.window!.isVisible) {
            self.mainWindowController.showWindow(mainWindowController?.window);
        }
    }
    
    @IBAction func addChild(_ sender: Any) {
        self.mainWindowController.mainSplitViewController.docTreeViewController.addChildTree(sender);
    }
    
    @IBAction func addBrother(_ sender: Any) {
        self.mainWindowController.mainSplitViewController.docTreeViewController.addTree(sender);
    }
    
    @IBAction func remove(_ sender: Any) {
        self.mainWindowController.mainSplitViewController.docTreeViewController.removeTree(sender);
    }
    
    @IBAction func cleanTrash(_ sender: Any) {
        self.mainWindowController.mainSplitViewController.docTreeViewController.cleanTrash(sender);
    }
    
    @IBAction func autoCreateTOC(_ sender: Any) {
        self.mainWindowController.mainSplitViewController.docTreeViewController.createDiary(sender);
    }
    
    @IBAction func editAndMainView(_ sender: Any) {
        self.mainWindowController.mainSplitViewController.docSplitViewController.showDocEditAndMainSplitView();
        editAndMainVIewMenu.state = 1;
        mainVIewMenu.state = 0;
        editVIewMenu.state = 0;
    }
    
    @IBAction func mainView(_ sender: Any) {
        self.mainWindowController.mainSplitViewController.docSplitViewController.showDocMainSplitView();
        editAndMainVIewMenu.state = 0;
        mainVIewMenu.state = 1;
        editVIewMenu.state = 0;
    }
    
    @IBAction func editView(_ sender: Any) {
        self.mainWindowController.mainSplitViewController.docSplitViewController.showDocEditSplitView();
        editAndMainVIewMenu.state = 0;
        mainVIewMenu.state = 0;
        editVIewMenu.state = 1;
    }
    
    @IBAction func exportHtml(_ sender: Any) {
        if self.mainWindowController.mainSplitViewController.docTreeViewController.selectedTree() == nil{
            AlertUtils.alert("无法操作", content: "请选择需要导出的文件或文件夹", buttons: ["确定"], buttonEvents: [{}])
            return;
        }
        self.export("html");
    }
    
    @IBAction func exportText(_ sender: Any) {
        if self.mainWindowController.mainSplitViewController.docTreeViewController.selectedTree() == nil{
            AlertUtils.alert("无法操作", content: "请选择需要导出的文件或文件夹", buttons: ["确定"], buttonEvents: [{}])
            return;
        }
        self.export("text");
    }
    
    func export(_ type: String){
        let selectedTree = self.mainWindowController.mainSplitViewController.docTreeViewController.selectedTree()!;
        // 文章还是文件夹
        let panel = NSSavePanel();
        panel.canCreateDirectories = true;
        // 如果是文章
        if selectedTree.children!.count <= 0 {
            panel.nameFieldStringValue = selectedTree.name!;
            panel.allowedFileTypes = [type];
            panel.allowsOtherFileTypes = false;
            panel.isExtensionHidden = true;
        }
            // 如果是目录
        else {
            panel.nameFieldStringValue = "MBase文件";
            panel.allowsOtherFileTypes = false;
            panel.isExtensionHidden = true;
        }
        if panel.runModal() == NSFileHandlingPanelOKButton {
            let manager = FileManager.default;
            let path = panel.url!.path;
            do {
                if selectedTree.children!.count > 0{
                    // 先建目录
                    try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: [:]);
                }
                try ExportUtils.exportFiles(manager, docTree: selectedTree, exportPath: path, type: type);
            } catch{
                let nserror = error as NSError;
                NSApplication.shared().presentError(nserror);
            }
        }
    }
    
}
