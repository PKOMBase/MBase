//
//  DocTreeInfoData.swift
//  MBase
//
//  Created by sunjie on 16/7/23.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class DocTreeInfoData: NSObject {
    
    var id: NSManagedObjectID!;
    
    var name: String!;
    
    var content: String!;
    
    var image: NSImage?;
    
    var isChangeImage: Bool?;
    
    override init() {
        self.id = NSManagedObjectID();
        self.name = "";
        self.content = "";
        self.image = nil;
        self.isChangeImage = false;
    }
    
    init(id: NSManagedObjectID!, name: String!,content: String!, image: NSImage?, isChangeImage: Bool?){
        self.id = id;
        self.name = name;
        self.content = content;
        self.image = image;
        if isChangeImage == nil {
            self.isChangeImage = false;
        } else {
            self.isChangeImage = isChangeImage;
        }
    }
    
}
