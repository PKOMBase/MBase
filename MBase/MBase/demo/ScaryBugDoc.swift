//
//  ScaryBugDoc.swift
//  MBase
//
//  Created by sunjie on 16/7/21.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class ScaryBugDoc: NSObject {

    var data: ScaryBugData;
    var thumbImage: NSImage?;
    var fullImage: NSImage?;
    
    override init() {
        self.data = ScaryBugData()
    }
    
    init(title: String, rating: Double, thumbImage: NSImage?, fullImage:NSImage?) {
        self.data = ScaryBugData(title: title, rating: rating)
        self.thumbImage = thumbImage
        self.fullImage = fullImage
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.data = decoder.decodeObject(forKey: "data") as! ScaryBugData
        self.thumbImage = decoder.decodeObject(forKey: "thumbImage") as! NSImage?
        self.fullImage = decoder.decodeObject(forKey: "fullImage") as! NSImage?
    }
    
}

// MARK: - NSCoding
extension ScaryBugDoc : NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(self.data, forKey: "data")
        coder.encode(self.thumbImage, forKey: "thumbImage")
        coder.encode(self.fullImage, forKey: "fullImage")
    }
    
}
