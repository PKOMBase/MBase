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
    
    func initRootDate(docTree: DocTree!){
        self.content = "";
        self.summary = "";
        self.mark = "";
        self.verticalScrol = 0;
        self.type = DocMainType.NotEdit.rawValue;
        let nowDate = NSDate()
        self.createtime = nowDate;
        self.modifytime = nowDate;
        self.docTree = docTree;
    }
    
    func initData(content: String!, summary: String?, mark: String?, type: DocMainType?, docTree: DocTree!) {
        self.content = content;
        self.summary = summary;
        self.mark = mark;
        if type == nil {
            self.type = DocMainType.Markdown.rawValue;
        } else {
            self.type = type!.rawValue;
        }
        let nowDate = NSDate()
        self.createtime = nowDate;
        self.modifytime = nowDate;
        self.docTree = docTree;
    }
    
    func updateVerticalScrol(verticalScrol: NSNumber){
        if self.verticalScrol != verticalScrol {
            self.verticalScrol = verticalScrol;
        }
    }

    func updateContent(content: String){
        if self.content != content{
            self.content = content;
            let nowDate = NSDate();
            self.modifytime = nowDate;
        }
    }
    
}
