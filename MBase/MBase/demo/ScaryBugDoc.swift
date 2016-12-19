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
        self.data = decoder.decodeObjectForKey("data") as! ScaryBugData
        self.thumbImage = decoder.decodeObjectForKey("thumbImage") as! NSImage?
        self.fullImage = decoder.decodeObjectForKey("fullImage") as! NSImage?
    }
    
}

// MARK: - NSCoding
extension ScaryBugDoc : NSCoding {
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.data, forKey: "data")
        coder.encodeObject(self.thumbImage, forKey: "thumbImage")
        coder.encodeObject(self.fullImage, forKey: "fullImage")
    }
    
}