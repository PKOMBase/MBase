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
        
        self.view.layer?.backgroundColor = NSColor.blue.cgColor;
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
    
    func changeRect(_ rect: NSRect){
        self.view.frame = rect;
        let width = rect.width;
        let height = rect.height;
        if !self.docEditViewController.view.isHidden && self.docMainViewController.view.isHidden {
            self.docEditViewController.view.frame = NSMakeRect(0, 0, width, height);
            self.docMainViewController.view.frame = NSMakeRect(width, 0, 0, height);
        }else
        if self.docEditViewController.view.isHidden && !self.docMainViewController.view.isHidden{
            self.docEditViewController.view.frame = NSMakeRect(0, 0, 0, height);
            self.docMainViewController.view.frame = NSMakeRect(0, 0, width, height);
        }else{
            self.docEditViewController.view.frame = NSMakeRect(0, 0, width / 2, height);
            self.docMainViewController.view.frame = NSMakeRect(width / 2, 0, width / 2, height);
        }
    }
    
    func showDocEditSplitView(){
        self.docEditViewController.view.isHidden = false;
        self.docMainViewController.view.isHidden = true;
        let width = self.view.frame.width;
        let height = self.view.frame.height;
        self.docEditViewController.view.frame = NSMakeRect(0, 0, width, height);
        self.docMainViewController.view.frame = NSMakeRect(width, 0, 0, height);
    }
    
    func showDocMainSplitView(){
        self.docEditViewController.view.isHidden = true;
        self.docMainViewController.view.isHidden = false;
        let width = self.view.frame.width;
        let height = self.view.frame.height;
        self.docEditViewController.view.frame = NSMakeRect(0, 0, 0, height);
        self.docMainViewController.view.frame = NSMakeRect(0, 0, width, height);
    }
    
    func showDocEditAndMainSplitView(){
        self.docEditViewController.view.isHidden = false;
        self.docMainViewController.view.isHidden = false;
        let width = self.view.frame.width;
        let height = self.view.frame.height;
        self.docEditViewController.view.frame = NSMakeRect(0, 0, width / 2, height);
        self.docMainViewController.view.frame = NSMakeRect(width / 2, 0, width / 2, height);
    }
    
}
