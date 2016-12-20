//
//  DocumentViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/21.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import Quartz

class DocumentViewController: NSViewController {
    
    @IBOutlet weak var bugsTableView: NSTableView!
    
    @IBOutlet weak var bugTitleView: NSTextField!
    
    @IBOutlet weak var bugRating: EDStarRating!
    
    @IBOutlet weak var bugImageView: NSImageView!
    
    @IBOutlet weak var deleteButton: NSButton!
    
    @IBOutlet weak var changePicButton: NSButton!
    
    @IBOutlet weak var nameLabel: NSTextField!
    
    @IBOutlet weak var ratingLabel: NSTextField!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var bugs = [ScaryBugDoc]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func setupSampleBugs() {
        let bug1 = ScaryBugDoc(title: "Potato Bug", rating: 4.0,
                               thumbImage:NSImage(named: "potatoBugThumb"), fullImage:NSImage(named: "potatoBug"))
        let bug2 = ScaryBugDoc(title: "House Centipede", rating: 3.0,
                               thumbImage:NSImage(named: "centipedeThumb"), fullImage:NSImage(named: "centipede"))
        let bug3 = ScaryBugDoc(title: "Wolf Spider", rating: 5.0,
                               thumbImage:NSImage(named: "wolfSpiderThumb"), fullImage:NSImage(named: "wolfSpider"))
        let bug4 = ScaryBugDoc(title: "Lady Bug", rating: 1.0,
                               thumbImage:NSImage(named: "ladybugThumb"), fullImage:NSImage(named: "ladybug"))
        bugs = [bug1, bug2, bug3, bug4]
    }
    
    func selectedBugDoc() -> ScaryBugDoc? {
        let selectedRow = self.bugsTableView.selectedRow;
        if selectedRow >= 0 && selectedRow < self.bugs.count {
            return self.bugs[selectedRow]
        }
        return nil
    }
    
    func updateDetailInfo(_ doc: ScaryBugDoc?) {
        var title = ""
        var image: NSImage?
        var rating = 0.0
        if let scaryBugDoc = doc {
            title = scaryBugDoc.data.title
            image = scaryBugDoc.fullImage
            rating = scaryBugDoc.data.rating
        }
        self.bugTitleView.stringValue = title
        self.bugImageView.image = image
        self.bugRating.rating = Float(rating)
    }
    
    func reloadSelectedBugRow() {
        let indexSet = IndexSet(integer: self.bugsTableView.selectedRow);
        let columnSet = IndexSet(integer: 0);
        self.bugsTableView.reloadData(forRowIndexes: indexSet, columnIndexes:columnSet);
    }
    
    func saveBugs() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self.bugs);
        UserDefaults.standard.set(data, forKey: "bugs");
        UserDefaults.standard.synchronize();
    }
    
    override func loadView() {
        super.loadView()
        self.bugRating.starHighlightedImage = NSImage(named:"shockedface2_full")
        self.bugRating.starImage = NSImage(named:"shockedface2_empty")
        self.bugRating.delegate = self as EDStarRatingProtocol;
        self.bugRating.maxRating = 5
        self.bugRating.horizontalMargin = 12
        self.bugRating.editable = false
        self.bugRating.displayMode = UInt(EDStarRatingDisplayFull)
        self.bugRating.rating = Float(0.0)
    }
    
    func doCoreData(){
        let tree = NSEntityDescription.insertNewObject(forEntityName: "Tree", into: self.managedObjectContext) as! DocTree;
        tree.name = "1231231231321";
        tree.content = "123123123123131312";
        
        do{
            try managedObjectContext.save();
        }catch{
            let nserror = error as NSError
            NSApplication.shared().presentError(nserror)
        }
        
        
//        let fetchRequest:NSFetchRequest = NSFetchRequest()
//        fetchRequest.fetchLimit = 10 //限定查询结果的数量
//        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        //声明一个实体结构
//        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Tree",
//                                                                            in: self.managedObjectContext)
        //设置数据请求的实体结构
//        fetchRequest.entity = entity
        
        //设置查询条件
//        let predicate = NSPredicate(format: "1=1 ", "")
//        fetchRequest.predicate = predicate
        
        //查询操作
//        do{
//            let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
//            //遍历查询的结果
//            for tree in fetchedObjects as! [DocTree]{
//                print("username=\(tree.name)")
//                print("password=\(tree.content)")
//            }
//        }catch{
//            let nserror = error as NSError
//            NSApplication.shared().presentError(nserror)
//        }

    }
    
}

// MARK: - NSTableViewDataSource
extension DocumentViewController: NSTableViewDataSource {
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        return self.bugs.count;
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // 1
        let cellView: NSTableCellView = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView;
        // 2
        if tableColumn!.identifier == "BugColumn" {
            // 3
            let bugDoc = self.bugs[row]
            cellView.imageView!.image = bugDoc.thumbImage
            cellView.textField!.stringValue = bugDoc.data.title
        }
        return cellView
    }
}

// MARK: - NSTableViewDelegate
extension DocumentViewController: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedDoc = selectedBugDoc();
        updateDetailInfo(selectedDoc);
        let enabled = (selectedDoc != nil);
        deleteButton.isEnabled = enabled;
        changePicButton.isEnabled = enabled;
        bugRating.editable = enabled;
        bugTitleView.isEnabled = enabled;
        let hidden = (selectedDoc == nil);
        nameLabel.isHidden = hidden;
        bugTitleView.isHidden = hidden;
        ratingLabel.isHidden = hidden;
        bugRating.isHidden = hidden;
        bugImageView.isHidden = hidden;
        changePicButton.isHidden = hidden;
    }
    
}

// MARK: -EDStarRatingProtocol
extension DocumentViewController: EDStarRatingProtocol {
    
    func starsSelectionChanged(_ control: EDStarRating!, rating: Float) {
        if let selectedDoc = selectedBugDoc() {
            selectedDoc.data.rating = Double(control.rating)
        }
    }
}







