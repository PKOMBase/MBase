//
//  DocTreeInfoViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/23.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocTreeInfoViewController: NSViewController {

    @IBOutlet weak var nameField: NSTextField!
    
    @IBOutlet var contentField: NSTextView!
    
    @IBOutlet weak var imageView: NSImageView!
    
    var docTreeInfoPopover: NSPopover?;
    
    var docTreeData : DocTree?;
    
    var docTreeInfoData : DocTreeInfoData?;
    
    var docTreeViewController: DocTreeViewController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化数据
        self.initView();
    }
    
    func initData(_ docTreeData: DocTree?) {
        self.docTreeData = docTreeData;
        self.docTreeInfoData = DocTreeInfoData();
        if docTreeData != nil {
            self.docTreeInfoData!.id = docTreeData!.objectID;
            self.docTreeInfoData!.name = docTreeData!.name;
            self.docTreeInfoData!.content = docTreeData!.content;
            if docTreeData!.image != nil {
                self.docTreeInfoData!.image = NSImage(data: docTreeData!.image! as Data);
            }
        }
    }
    
    func initView() {
        if self.docTreeInfoData == nil {
            return;
        }
        self.nameField.stringValue = self.docTreeInfoData!.name;
        self.contentField.string = self.docTreeInfoData!.content;
        self.imageView.image = self.docTreeInfoData!.image;
    }
    
    func showPopover(_ ofView: NSView!,docTreeViewController: DocTreeViewController!){
        self.docTreeInfoPopover = NSPopover();
        self.docTreeInfoPopover!.contentViewController = self;
        self.docTreeInfoPopover!.delegate = self;
        self.docTreeInfoPopover!.behavior = NSPopoverBehavior.transient;
        self.docTreeInfoPopover!.show(relativeTo: ofView!.bounds, of: ofView!, preferredEdge: NSRectEdge.maxY);
        self.docTreeViewController = docTreeViewController;
    }
    
}
