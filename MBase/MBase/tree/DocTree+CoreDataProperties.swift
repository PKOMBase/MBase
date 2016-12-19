//
//  DocTree+CoreDataProperties.swift
//  MBase
//
//  Created by sunjie on 16/8/5.
//  Copyright © 2016年 popkidorc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DocTree {

    @NSManaged var content: String?
    @NSManaged var image: NSData?
    @NSManaged var name: String?
    @NSManaged var modifytime: NSDate?
    @NSManaged var createtime: NSDate?
    @NSManaged var type: String?
    @NSManaged var status: String?
    @NSManaged var children: NSMutableOrderedSet?
    @NSManaged var parent: DocTree?
    @NSManaged var docMain: DocMain?

}
