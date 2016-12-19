//
//  ScaryBugData.swift
//  MBase
//
//  Created by sunjie on 16/7/21.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class ScaryBugData : NSObject {
    
    var title: String;
    
    var rating: Double;
    
    override init() {
        self.title = String();
        self.rating = 0.0;
    }
    
    init(title: String, rating: Double) {
        self.title = title;
        self.rating = rating;
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.title = decoder.decodeObjectForKey("title") as! String
        self.rating = decoder.decodeObjectForKey("rating") as! Double
    }
}

// MARK: - NSCoding
extension ScaryBugData : NSCoding {
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.title, forKey: "title");
        coder.encodeObject(Double(self.rating), forKey: "rating");
    }
    
}