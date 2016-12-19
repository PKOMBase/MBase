////
////  TreeBack.swift
////  MBase
////
////  Created by sunjie on 16/8/5.
////  Copyright © 2016年 popkidorc. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//
//class Tree: NSManagedObject {
//    
//    var isHasChild: Bool!;
//    
//    var parent: Tree?;
//    
//    var children: [Tree]?;
//    
//    func initData4Root() {
//        self.name = "root";
//        self.number = NSNumber(long: -1);
//        self.image = nil;
//        self.level = NSNumber(long: 0);
//        self.parent = nil;
//        self.isHasChild = false;
//        self.children = [Tree]();
//        self.content = "";
//        self.path = "-1/0/";
//        self.parentId = NSNumber(long: -1);
//    }
//    
//    func initData(id: Int!, name: String!, image: NSImage?, parent: Tree!){
//        self.id = NSNumber(long: id!);
//        self.name = name;
//        if parent == nil {
//            self.number = NSNumber(long: 0);
//        } else if parent.children == nil || parent.children!.count <= 0 {
//            self.number = NSNumber(long: 1);
//        } else {
//            self.number = NSNumber(long: parent.children!.last!.number!.longValue + 1 );
//        }
//        if image == nil{
//            self.image = nil;
//        } else {
//            self.image = image?.TIFFRepresentation;
//        }
//        if parent == nil {
//            self.path = String(id!) + "/";
//            self.level = NSNumber(long: 0);
//        }else{
//            self.path = String(parent!.id!.longValue) + "/";
//            self.level = NSNumber(long: parent!.level!.longValue + 1);
//        }
//        var parentId = -1;
//        if parent != nil {
//            parentId = parent!.id!.longValue;
//        }
//        self.parentId = NSNumber(long: parentId)
//        self.isHasChild = false;
//        self.content = "";
//        self.children = [Tree]();
//        self.parent = parent;
//    }
//    
//    func setChildrenTree(children: [Tree]?){
//        if children == nil || children?.count <= 0 {
//            self.isHasChild = false;
//            self.children = [Tree]();
//        } else {
//            self.isHasChild = true;
//            self.children = children;
//        }
//    }
//    
//    func addChildTree(child: Tree!){
//        if self.children == nil{
//            self.children = [Tree]();
//        }
//        self.isHasChild = true;
//        self.children?.append(child);
//    }
//    
//    func getIndex() -> Int?{
//        if self.parent == nil {
//            return nil;
//        }
//        return self.parent!.children?.indexOf(self);
//    }
//    
//    func getChildById(id: Int!) -> Tree?{
//        if self.children == nil || self.children?.count <= 0 {
//            if id == self.id {
//                return self;
//            }else{
//                return nil;
//            }
//        }
//        for child in self.children! {
//            return child.getChildById(id);
//        }
//        return nil;
//    }
//    
//    func remove(){
//        let index = self.getIndex();
//        if index != nil {
//            self.parent?.children?.removeAtIndex(index!);
//        }
//    }
//    
//}
