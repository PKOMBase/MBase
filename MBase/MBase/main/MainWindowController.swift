//
//  MainWindowController.swift
//  MBase
//
//  Created by sunjie on 16/7/21.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    var mainSplitViewController: MainSplitViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    var userInfo: UserInfo!;
    
    func initWindow(){
        self.contentViewController = NSViewController();
        print("NSScreen.mainScreen()!:"+String(describing: NSScreen.main()!.frame.width)+", "+String(describing: NSScreen.main()!.frame.height));
        self.contentViewController?.view = NSView(frame: NSRect(x: 0, y: 0, width: NSScreen.main()!.frame.width, height: NSScreen.main()!.frame.height));
    }
    
    override func windowDidLoad() {
        super.windowDidLoad();
        
        // 1. 创建viewController
        mainSplitViewController = MainSplitViewController(nibName: "MainSplitViewController", bundle: nil);
        mainSplitViewController.managedObjectContext = self.managedObjectContext;
        mainSplitViewController.userInfo = self.userInfo;
        contentViewController!.addChildViewController(mainSplitViewController);
        
        // 2. 添加view
        contentViewController!.view.addSubview(mainSplitViewController.view);
        mainSplitViewController.view.frame = contentViewController!.view.bounds;
        
        // 3. 设置masterViewController.view的布局约束
        mainSplitViewController.view.translatesAutoresizingMaskIntoConstraints = false;
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                                 options: NSLayoutFormatOptions(rawValue: 0),
                                                                                 metrics: nil,
                                                                                 views: ["subView" : mainSplitViewController.view]);
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                                   metrics: nil,
                                                                                   views: ["subView" : mainSplitViewController.view]);
        NSLayoutConstraint.activate(verticalConstraints + horizontalConstraints);
    }
    
}
