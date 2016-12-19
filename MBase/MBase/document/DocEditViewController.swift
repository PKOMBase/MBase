//
//  DocEditViewController.swift
//  MBase
//
//  Created by sunjie on 16/8/3.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import CoreData
import WebKit
import MBaseMarkdown

class DocEditViewController: NSViewController {
    
    @IBOutlet var docEditView: NSTextView!
    
    @IBOutlet weak var docEditScrollView: NSScrollView!
    
    var docMainData: DocMain!;
    
    var docMainViewController: DocMainViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    var editedRange: NSRange?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        initDocEidtView();
    }
    
    func initDocEditDatas(docMainData: DocMain!){
        self.docMainData = docMainData;
        
        if DocMain.DocMainType.NotEdit.rawValue == docMainData.type {
            self.docEditView.editable = false;
            self.docEditView.backgroundColor = MarkdownConstsManager.docEditDisableBgColor;
        }else{
            self.docEditView.editable = true;
            self.docEditView.backgroundColor = MarkdownConstsManager.docEditEnableBgColor;
        }
        self.docEditView.string = docMainData.content!
        
        self.handlerInitFont();
        
        self.docMainViewController.markdown = docMainData.content!;

        self.docMainViewController.reloadHTML();
        
        NSNotificationCenter.defaultCenter().postNotificationName("setScroll", object: nil);
    }

    func cleanDocEditDatas(){
        self.docEditView.editable = false;
        self.docEditView.backgroundColor = MarkdownConstsManager.docEditDisableBgColor;
        self.docEditView.string = ""
        
        self.handlerInitFont();
        
        self.docMainViewController.markdown = "";
        
        self.docMainViewController.reloadHTML();
    }
    
    func initDocEidtView() {
        // 3. View属性
        self.docEditView.textContainerInset = NSSize(width: 10, height: 50);
        // 3.1. 拉宽自动补充
        self.docEditView.textContainer!.widthTracksTextView = true;

        // 3.2. 剪切版
        self.docEditView.registerForDraggedTypes([NSPasteboardTypeString, NSPasteboardTypePNG]);
        // 3.3. 状态＋颜色
        self.docEditView.backgroundColor = MarkdownConstsManager.docEditDisableBgColor;
        self.docEditView.font = NSFont.systemFontOfSize(MarkdownConstsManager.defaultFontSize);
        self.docEditView.defaultParagraphStyle = MarkdownConstsManager.getDefaultParagraphStyle();
        self.docEditView.textColor = MarkdownConstsManager.defaultFontColor;
        self.docEditView.textStorage?.delegate = self;
        
        self.docEditView.automaticQuoteSubstitutionEnabled = false;
        self.docEditView.automaticLinkDetectionEnabled = false;
        self.docEditView.automaticDashSubstitutionEnabled = false;
        self.docEditView.automaticTextReplacementEnabled = false;
        self.docEditView.automaticDataDetectionEnabled = false;
        self.docEditView.automaticSpellingCorrectionEnabled = false;
        self.docEditView.smartInsertDeleteEnabled = true;
        self.docEditView.allowsUndo = true;

        //给滚动条添加通知        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeScroll), name: NSViewBoundsDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setScroll), name: "setScroll", object: nil);
    }
    
    func changeScroll(){
        if !docEditScrollView.hasVerticalScroller {
            return;
        }
        if self.docMainData.verticalScrol == self.docEditView.enclosingScrollView!.contentView.bounds.origin.y {
            return;
        }
        self.docMainData.updateVerticalScrol(self.docEditView.enclosingScrollView!.contentView.bounds.origin.y);
        self.docMainViewController.docEditVerticalScroller = self.docEditScrollView.verticalScroller!;
        self.docMainViewController.syncScroll();
    }
    
    func setScroll() {
//        print("+++++++"+String(scrollLocation)+"==="+String(docMainData.verticalScrol!));
        let scrollLocation = self.docEditView.enclosingScrollView?.contentView.bounds.origin.y;
        
        print("+++++++"+String(scrollLocation)+"==="+String(docMainData.verticalScrol!)+"==="+String(self.docEditView.enclosingScrollView?.documentView?.frame.height));
        
        self.docEditScrollView.contentView.scrollPoint(NSMakePoint(0, CGFloat(1000)));
        
        self.docEditScrollView.reflectScrolledClipView(self.docEditScrollView.contentView);
        
    }
    
}