//
//  DocSplitViewController.swift
//  MBase
//
//  Created by sunjie on 16/9/25.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocSplitViewController: NSViewController {

    var docEditViewController: DocEditViewController!;

    var docMainViewController: DocMainViewController!;

    var managedObjectContext: NSManagedObjectContext!;
    
    var userInfo: UserInfo!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer?.backgroundColor = NSColor.blueColor().CGColor;
        self.view.needsDisplay = true;
        
        docMainViewController = DocMainViewController(nibName: "DocMainViewController", bundle: nil);
        
        docEditViewController = DocEditViewController(nibName: "DocEditViewController", bundle: nil);

        docEditViewController.docMainViewController = docMainViewController;
        docEditViewController.managedObjectContext = self.managedObjectContext;
     
        self.addChildViewController(docEditViewController);
        self.view.addSubview(docEditViewController.view);

        self.addChildViewController(docMainViewController);
        self.view.addSubview(docMainViewController.view);
        
    }
    
    func changeRect(rect: NSRect){
        self.view.frame = rect;
        let width = rect.width;
        let height = rect.height;
        self.docEditViewController.view.frame = NSMakeRect(0, 0, width / 2, height);
        self.docMainViewController.view.frame = NSMakeRect(width / 2, 0, width / 2, height);
    }
    
}
