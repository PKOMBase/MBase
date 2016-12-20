//
//  DocMain.swift
//  MBase
//
//  Created by sunjie on 16/8/5.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Foundation
import CoreData


class DocMain: NSManagedObject {
    
    enum DocMainType : String {
        case Markdown = "Markdown"
        case NotEdit = "NotEdit"
    }
    
    func initRootDate(_ docTree: DocTree!){
        self.content = "";
        self.summary = "";
        self.mark = "";
        self.verticalScrol = 0;
        self.type = DocMainType.NotEdit.rawValue;
        let nowDate = Date()
        self.createtime = nowDate as NSDate?;
        self.modifytime = nowDate as NSDate?;
        self.docTree = docTree;
    }
    
    func initData(_ content: String!, summary: String?, mark: String?, type: DocMainType?, docTree: DocTree!) {
        self.content = content;
        self.summary = summary;
        self.mark = mark;
        if type == nil {
            self.type = DocMainType.Markdown.rawValue;
        } else {
            self.type = type!.rawValue;
        }
        let nowDate = Date()
        self.createtime = nowDate as NSDate?;
        self.modifytime = nowDate as NSDate?;
        self.docTree = docTree;
    }
    
    func updateVerticalScrol(_ verticalScrol: NSNumber){
        if self.verticalScrol != verticalScrol {
            self.verticalScrol = verticalScrol;
        }
    }

    func updateContent(_ content: String){
        if self.content != content{
            self.content = content;
            let nowDate = Date();
            self.modifytime = nowDate as NSDate?;
        }
    }
    
}
