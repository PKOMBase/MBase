//
//  DocMainViewController.swift
//  MBase
//
//  Created by sunjie on 16/7/22.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import WebKit
import MBaseMarkdown

class DocMainViewController: NSViewController {
    
    @IBOutlet weak var webView: WebView!
    
    var markdown: String!;
    
    var docEditVerticalScroller: NSScroller?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    func refreshContent(){
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(reloadHTML), object: nil);
        self.performSelector(#selector(reloadHTML), withObject: nil, afterDelay: 0.2);
    }
    
    func reloadHTML(){
        let start = CFAbsoluteTimeGetCurrent()
        let html = MarkdownManager.generateHTMLForMarkdown(self.markdown!, cssType: .Default);
        webView.mainFrame.loadHTMLString(html as String, baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!, isDirectory: true));
        print("refreshContent===="+String(CFAbsoluteTimeGetCurrent()-start)+" seconds")
    }
    
    func syncScroll(){
        if docEditVerticalScroller == nil || self.webView == nil{
            return;
        }
        let webHtmlView = self.webView!.subviews[0].subviews[0].subviews[0].subviews[0];
        let webScrollView = self.webView!.subviews[0].subviews[0] as! NSScrollView;
        var frame = webScrollView.frame;
        if webHtmlView.frame.size.height > frame.size.height {
            frame.origin.y = (webHtmlView.frame.size.height - frame.size.height) * CGFloat(docEditVerticalScroller!.floatValue);
            webScrollView.contentView.scrollRectToVisible(frame);
        }
    }
}


