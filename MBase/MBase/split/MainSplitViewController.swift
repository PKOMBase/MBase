//
//  MainSplitViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {
    
    var docTreeViewController: DocTreeViewController!;
    
    var docSplitViewController: DocSplitViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    var userInfo: UserInfo!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1 创建viewController
        let allWidth = self.parentViewController!.view.frame.size.width;
        let allHeight = self.parentViewController!.view.frame.size.height;
        
        docSplitViewController = DocSplitViewController(nibName: "DocSplitViewController", bundle: nil);
        docSplitViewController.view.frame = NSMakeRect(0, 0, allWidth * ConstsManager.docSplitViewWidthRatio, allHeight);

        let docSplitViewItem = NSSplitViewItem(viewController: docSplitViewController);
        self.addSplitViewItem(docSplitViewItem)

        docTreeViewController = DocTreeViewController(nibName: "DocTreeViewController", bundle: nil);
        docTreeViewController.docEditViewController = docSplitViewController.docEditViewController;
        docTreeViewController.managedObjectContext = self.managedObjectContext;
        docTreeViewController.userInfo = self.userInfo;
        docTreeViewController.initDocTreeDatas();
        docTreeViewController.view.frame = NSMakeRect(0, 0, allWidth - docSplitViewController.view.frame.width, allHeight);
        
        //需要先加载docEditViewController
        let treeSplitViewItem = NSSplitViewItem(viewController: docTreeViewController);

        self.insertSplitViewItem(treeSplitViewItem, atIndex: 0);

    }
    
    override func splitViewDidResizeSubviews(notification: NSNotification) {
        let width = self.view.frame.width - docTreeViewController.view.frame.width;
        let height = self.view.frame.height;
        
        self.docSplitViewController.changeRect(NSMakeRect(0, 0, width, height));
    }
    
}
