//
//  DocTreeViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import CoreData
import MBaseMarkdown

class DocTreeViewController: NSViewController, NSDraggingDestination {

    @IBOutlet weak var docTreeView: NSOutlineView!
    
    var docTreeData: DocTree!;
    
    var docEditViewController: DocEditViewController!;
    
    var docMainViewController: DocMainViewController!;
    
    var managedObjectContext: NSManagedObjectContext!;
    
    var userInfo: UserInfo!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.docTreeView.registerForDraggedTypes([NSPasteboardTypeString]);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeDocImageAll), name: "changeDocImageAll", object: nil);
        // 自动展开并记录的节点
        if let selectedDocTree = self.userInfo.selectDocTree {
            // 展开节点
            let parents = selectedDocTree.getParents();
            if parents.count>=1{
                for i in 1...parents.count {
                    self.docTreeView.expandItem(parents[parents.count-i]);
                }
            }
            let newSelectedRow = self.docTreeView.rowForItem(selectedDocTree);
            self.docTreeView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
            self.docTreeView.scrollRowToVisible(newSelectedRow);
        }
    }
    
    @IBAction func doubleAction(sender: AnyObject) {
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        if self.docTreeView.isItemExpanded(selectedDocTree){
            self.docTreeView.collapseItem(selectedDocTree);
        } else {
            self.docTreeView.expandItem(selectedDocTree);
        }
    }
    
    override func keyDown(theEvent: NSEvent) {
        print("theEvent:"+String(theEvent.keyCode))
        //回车
        if 36 == theEvent.keyCode{
            self.showDocTreeInfoPopover();
        }
    }
    
    func showDocTreeInfoPopover(){
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        if DocTree.DocTreeType.Trash.rawValue == selectedDocTree?.type {
            return;
        }
        
        let docTreeInfoViewController = DocTreeInfoViewController(nibName: "DocTreeInfoViewController", bundle: nil);
        docTreeInfoViewController!.initData(selectedDocTree);
        
        let newSelectedRow = self.docTreeView.rowForItem(selectedDocTree);
        let rowView = self.docTreeView.rowViewAtRow(newSelectedRow, makeIfNecessary: false);
        
        docTreeInfoViewController!.showPopover(rowView, docTreeViewController: self);
    }
    
    func initDocTreeDatas() {
        // 1. 加载数据，查询coredata
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        //        fetchRequest.fetchOffset = 0 //查询的偏移量
        //设置数据请求的实体结构
        fetchRequest.entity = NSEntityDescription.entityForName("DocTree",
                                                                inManagedObjectContext: self.managedObjectContext);
        //设置查询条件
        let predicate = NSPredicate(format: "1=1 ", "")
        fetchRequest.predicate = predicate
        
        //查询操作
        var trees = [DocTree]();
        do{
            trees = try managedObjectContext.executeFetchRequest(fetchRequest) as! [DocTree];
        }catch{
            let nserror = error as NSError
            NSApplication.sharedApplication().presentError(nserror)
        }
        
        // 遍历查询的结果
        if trees.count > 0 {
            // 1.1. 添加到coredata
            self.initDataByCoreData(trees);
        } else {
            // 1.2. 初始化默认值
            self.initDataByDefaultData();
        }
    }
    
    func initDataByCoreData(trees: [DocTree]){
        for tree in trees {
            if DocTree.DocTreeType.Root.rawValue == tree.type {
                docTreeData = tree;
            }
        }
    }
    
    // 初始化默认值
    func initDataByDefaultData(){
        self.docTreeData = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        let mainRoot = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
        mainRoot.initRootDate(self.docTreeData);
        docTreeData.initData4Root(mainRoot);
        
        let tree1 = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        let main1 = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
        main1.initData("", summary: "", mark: "", type: DocMain.DocMainType.NotEdit, docTree: tree1);
        tree1.initData("废纸篓", content: "废纸篓", image: NSImage(named: "TrashIcon"), type: DocTree.DocTreeType.Trash, parent: docTreeData, docMain: main1);
        
        let tree11 = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        let main11 = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
        main11.initData("", summary: "", mark: "", type: DocMain.DocMainType.NotEdit, docTree: tree11);
        tree11.initData("日记", content: "日记", image: NSImage(named: "DiaryIcon"), type: DocTree.DocTreeType.Diary, parent: docTreeData, docMain: main11);
        
        let tree12 = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        let main12 = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
        main12.initData("", summary: "", mark: "", type: DocMain.DocMainType.Markdown, docTree: tree12);
        tree12.initData("便签", content: "便签", image: NSImage(named: "NoteIcon"), type: DocTree.DocTreeType.Note, parent: docTreeData, docMain: main12);
        
        let tree2 = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as! DocTree;
        let main2 = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
        main2.initData(MarkdownConstsManager.getMarkdownHelp(), summary: "markdown使用帮助", mark: "markdown", type: DocMain.DocMainType.Markdown, docTree: tree2);
        tree2.initData("我的文档", content: "我的文档", image: NSImage(named: "HomeFolderIcon"), type: DocTree.DocTreeType.Normal, parent: docTreeData, docMain: main2);
        
        docTreeData.addChildTree(tree1);
        docTreeData.addChildTree(tree11);
        docTreeData.addChildTree(tree12);
        docTreeData.addChildTree(tree2);
    }
    
    func selectedTree() -> DocTree? {
        let selectedRow = self.docTreeView.selectedRow;
        if selectedRow >= 0 {
            return docTreeView.itemAtRow(selectedRow) as? DocTree;
        }
        return nil
    }
    
    func changeSelectedData(docTreeInfoData : DocTreeInfoData!, selectedDocTree: DocTree!){
        // 1. 更新Tree
        var docTreeType = DocTree.DocTreeType.Normal;
        if DocTree.DocTreeType.Normal.rawValue == selectedDocTree.type && docTreeInfoData.isChangeImage! {
            docTreeType = DocTree.DocTreeType.Custom;
        }
        selectedDocTree.updateData(docTreeInfoData.name, content: docTreeInfoData.content, image: docTreeInfoData.image, type: docTreeType);
        
        // 2. 重载数据
        self.reloadData(selectedDocTree);
    }
    
    func moveNode(sourceDocTree: DocTree, targetParentDocTree: DocTree, targetIndex: Int?){
        if sourceDocTree.parent == nil{
            return;
        }
        var childIndex: Int;
        if targetIndex == nil{
            childIndex = targetParentDocTree.children!.count;
        } else {
            childIndex = targetIndex!;
        }
        // 1. 更新Tree
        targetParentDocTree.insertChildTree(sourceDocTree, index: childIndex);
        if sourceDocTree.parent! != targetParentDocTree{
            //原父类移除该Doctree,由于index原因需要在insert之后执行
            sourceDocTree.parent!.removeChild(sourceDocTree);
            sourceDocTree.updateParentTree(targetParentDocTree);
        }
        
        // 2. 重载数据
        self.reloadData();
        
        // 3. 选中并滚动到新行
        let newSelectedRow = self.docTreeView.rowForItem(sourceDocTree);
        self.docTreeView.selectRowIndexes(NSIndexSet(index: newSelectedRow), byExtendingSelection:false);
        self.docTreeView.scrollRowToVisible(newSelectedRow);
    }
    
    func reloadData(){
        // 1. 改变图标
        self.changeSysImage();
        // 2. 重载数据
        self.docTreeView.reloadData();
    }
    
    func reloadData(selectedDocTree: DocTree){
        // 1. 改变图标
        self.changeSysImage();
        // 2. 重载数据
        let selectedRow = self.docTreeView.rowForItem(selectedDocTree);
        let indexSet = NSIndexSet(index: selectedRow);
        let columnSet = NSIndexSet(index: 0);
        self.docTreeView.reloadDataForRowIndexes(indexSet, columnIndexes:columnSet);
    }
    
    func changeSysImage(){
        if docTreeData == nil || docTreeData.children!.count < 0{
            return;
        }
        for child in docTreeData.children! {
            let docTree = child as! DocTree;
            if DocTree.DocTreeType.Trash.rawValue == docTree.type {
                if docTree.children!.count > 0 {
                    docTree.image = NSImage(named: "FullTrashIcon")?.TIFFRepresentation;
                } else {
                    docTree.image = NSImage(named: "TrashIcon")?.TIFFRepresentation;
                }
            }
        }
    }
    
    func changeDocImageAll(){
        let selectedDocTree = self.selectedTree();
        if selectedDocTree == nil {
            return;
        }
        self.changeDocImage(selectedDocTree!.parent!);
        self.changeDocImage(selectedDocTree!);
    }
    
    func changeDocImage(docTree: DocTree){
        if DocTree.DocTreeType.Custom.rawValue == docTree.type {
            return;
        }
        if docTree.parent == nil{
            return;
        }
        if DocTree.DocTreeType.Root.rawValue == docTree.parent!.type {
            return;
        }
        var newImage: NSImage?;
        if docTree.children?.count <= 0 {
            if docTree.docMain?.content != "" {
                newImage = NSImage(named: "GenericDocumentIcon")!;
            } else {
                newImage = NSImage(named: "GenericFolderIcon")!;
            }
        } else {
            if docTree.docMain?.content != "" {
                newImage = NSImage(named: "DocumentsFolderIcon")!;
            }
        }
        if newImage != nil && docTree.image != newImage!.TIFFRepresentation{
            docTree.image = newImage!.TIFFRepresentation;
            self.reloadData(docTree);
        }
    }
    
    func expandParent(docTree : DocTree){
        if DocTree.DocTreeType.Root.rawValue == docTree.type!{
            
            
            return;
        }
        if docTree.parent != nil{
            self.docTreeView.expandItem(docTree.parent!);
            self.expandParent(docTree.parent!);
        }
    }
    
    func createDiaryTree(selectedDocTree: DocTree) -> DocTree{
        // 组装日期
        let startDate = DateUtils.getStartOfCurrentMonth()
        let endDate = DateUtils.getEndOfCurrentMonth();
        
        let formatter = NSDateFormatter()
        //年
        formatter.dateFormat = "yyyy"
        let year = formatter.stringFromDate(endDate)
        
        //月
        formatter.dateFormat = "MM"
        let month = formatter.stringFromDate(endDate)
        
        //日
        formatter.dateFormat = "dd"
        let endDay = formatter.stringFromDate(endDate);
        let day1 = "01-10"
        let day2 = "11-20"
        let day3 = "21-"+endDay
        
        // 1. 年Tree
        var yearTree: DocTree?;
        for child in (selectedDocTree.children)!{
            if child.name == year{
                yearTree = child as? DocTree;
                break;
            }
        }
        if yearTree == nil {
            yearTree = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as? DocTree;
            let yearMain = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
            yearMain.initData("", summary: "", mark: "", type: DocMain.DocMainType.NotEdit, docTree: yearTree);
            yearTree!.initData(year, content: "", image: NSImage(named: "GenericFolderIcon"), type: DocTree.DocTreeType.DiaryChild,  parent: selectedDocTree, docMain: yearMain);
            
            selectedDocTree.addChildTree(yearTree);
        }
        
        // 2. 月Tree
        var monthTree: DocTree?;
        for child in (yearTree!.children)!{
            if child.name == month{
                monthTree = child as? DocTree;
                break;
            }
        }
        if monthTree == nil {
            monthTree = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as? DocTree;
            let monthMain = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
            monthMain.initData("", summary: "", mark: "", type: DocMain.DocMainType.NotEdit, docTree: monthTree);
            monthTree!.initData(month, content: "", image: NSImage(named: "GenericFolderIcon"), type: DocTree.DocTreeType.DiaryChild,  parent: yearTree!, docMain: monthMain);
            
            yearTree!.addChildTree(monthTree);
        }
        
        // 3. 日Tree
        var day1Tree: DocTree?;
        var day2Tree: DocTree?;
        var day3Tree: DocTree?;
        for child in (monthTree!.children)!{
            if child.name == day1{
                day1Tree = child as? DocTree;
                continue;
            } else
                if child.name == day2{
                    day2Tree = child as? DocTree;
                    continue;
                } else
                    if child.name == day3{
                        day3Tree = child as? DocTree;
                        continue;
            }
        }
        var content: String;
        if day1Tree == nil {
            day1Tree = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as? DocTree;
            let day1Main = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
            content = "";
            formatter.dateFormat = ConstsManager.docTreeDiaryDateformatter;
            for i in 0...9 {
                content += "# "+formatter.stringFromDate(DateUtils.getAddDays(startDate, days: i)) + "\n\n\n\n";
            }
            day1Main.initData(content, summary: "", mark: "", type: DocMain.DocMainType.Markdown, docTree: day1Tree);
            day1Tree!.initData(day1, content: "", image: NSImage(named: "GenericFolderIcon"), type: DocTree.DocTreeType.DiaryChild,  parent: monthTree!, docMain: day1Main);
            
            monthTree!.addChildTree(day1Tree);
        }
        if day2Tree == nil {
            day2Tree = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as? DocTree;
            let day2Main = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
            content = "";
            formatter.dateFormat = ConstsManager.docTreeDiaryDateformatter;
            for i in 10...19 {
                content += "# "+formatter.stringFromDate(DateUtils.getAddDays(startDate, days: i)) + "\n\n\n\n";
            }
            day2Main.initData(content, summary: "", mark: "", type: DocMain.DocMainType.Markdown, docTree: day2Tree);
            day2Tree!.initData(day2, content: "", image: NSImage(named: "GenericFolderIcon"), type: DocTree.DocTreeType.DiaryChild,  parent: monthTree!, docMain: day2Main);
            
            monthTree!.addChildTree(day2Tree);
        }
        if day3Tree == nil {
            day3Tree = NSEntityDescription.insertNewObjectForEntityForName("DocTree", inManagedObjectContext: self.managedObjectContext) as? DocTree;
            let day3Main = NSEntityDescription.insertNewObjectForEntityForName("DocMain", inManagedObjectContext: self.managedObjectContext) as! DocMain;
            content = "";
            formatter.dateFormat = ConstsManager.docTreeDiaryDateformatter;
            for i in 20...Int(endDay)!-1 {
                content += "# "+formatter.stringFromDate(DateUtils.getAddDays(startDate, days: i)) + "\n\n\n\n";
            }
            day3Main.initData(content, summary: "", mark: "", type: DocMain.DocMainType.Markdown, docTree: day3Tree);
            day3Tree!.initData(day3, content: "", image: NSImage(named: "GenericFolderIcon"), type: DocTree.DocTreeType.DiaryChild,  parent: monthTree!, docMain: day3Main);
            
            monthTree!.addChildTree(day3Tree);
        }
        
        // 3. 重载数据
        self.reloadData();
        
        // 4. 展开选中节点
        self.docTreeView.expandItem(selectedDocTree);
        self.docTreeView.expandItem(yearTree!);
        self.docTreeView.expandItem(monthTree!);
        
        // 5. 选中节点
        var newSelectedTree: DocTree;
        formatter.dateFormat = "dd"
        let nowDay = Int(formatter.stringFromDate(NSDate()));
        if nowDay<=10 {
            newSelectedTree = day1Tree!;
        } else if nowDay>=21 {
            newSelectedTree = day3Tree!;
        } else {
            newSelectedTree = day2Tree!;

        }
        return newSelectedTree;
    }
}

