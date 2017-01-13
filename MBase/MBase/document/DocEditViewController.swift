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
    
    func initDocEditDatas(_ docMainData: DocMain!){
        self.docMainData = docMainData;
        
        if DocMain.DocMainType.NotEdit.rawValue == docMainData.type {
            self.docEditView.isEditable = false;
            self.docEditView.backgroundColor = MarkdownConstsManager.docEditDisableBgColor;
        }else{
            self.docEditView.isEditable = true;
            self.docEditView.backgroundColor = MarkdownConstsManager.docEditEnableBgColor;
        }
        self.docEditView.string = docMainData.content!
        
        self.handlerInitFont();
        
        self.docMainViewController.markdown = docMainData.content!;

        self.docMainViewController.reloadHTML();
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScroll"), object: nil);
    }

    func cleanDocEditDatas(){
        self.docEditView.isEditable = false;
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
        self.docEditView.register(forDraggedTypes: [NSPasteboardTypeString, NSPasteboardTypePNG]);
        // 3.3. 状态＋颜色
        self.docEditView.backgroundColor = MarkdownConstsManager.docEditDisableBgColor;
        self.docEditView.font = NSFont.systemFont(ofSize: MarkdownConstsManager.defaultFontSize);
        self.docEditView.defaultParagraphStyle = MarkdownConstsManager.getDefaultParagraphStyle();
        self.docEditView.textColor = MarkdownConstsManager.defaultFontColor;
        self.docEditView.textStorage?.delegate = self;
        
        self.docEditView.isAutomaticQuoteSubstitutionEnabled = false;
        self.docEditView.isAutomaticLinkDetectionEnabled = false;
        self.docEditView.isAutomaticDashSubstitutionEnabled = false;
        self.docEditView.isAutomaticTextReplacementEnabled = false;
        self.docEditView.isAutomaticDataDetectionEnabled = false;
        self.docEditView.isAutomaticSpellingCorrectionEnabled = false;
        self.docEditView.smartInsertDeleteEnabled = true;
        self.docEditView.allowsUndo = true;

        //给滚动条添加通知        
        NotificationCenter.default.addObserver(self, selector: #selector(changeScroll), name: NSNotification.Name.NSViewBoundsDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setScroll), name: NSNotification.Name(rawValue: "setScroll"), object: nil);
    }
    
    func changeScroll(){
        if !docEditScrollView.hasVerticalScroller {
            return;
        }
        let originY = self.docEditView.enclosingScrollView!.contentView.bounds.origin.y as NSNumber;
        if self.docMainData.verticalScrol == originY{
            return;
        }
        self.docMainData.updateVerticalScrol(originY);
        self.docMainViewController.docEditVerticalScroller = self.docEditScrollView.verticalScroller!;
        self.docMainViewController.syncScroll();
    }
    
    func setScroll() {
        
        self.docEditScrollView.contentView.scroll(NSMakePoint(0, CGFloat(1000)));

        self.docEditScrollView.reflectScrolledClipView(self.docEditScrollView.contentView);
        
    }
    
}
