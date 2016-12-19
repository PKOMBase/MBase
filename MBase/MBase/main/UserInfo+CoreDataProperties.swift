//
//  UserInfo+CoreDataProperties.swift
//  MBase
//
//  Created by sunjie on 16/8/8.
//  Copyright © 2016年 popkidorc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserInfo {

    @NSManaged var modifytime: NSDate?
    @NSManaged var createtime: NSDate?
    @NSManaged var selectDocTree: DocTree?

}
