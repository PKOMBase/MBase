//
//  DocMainViewController+Delegate.swift
//  MBase
//
//  Created by sunjie on 16/8/9.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa
import WebKit

extension DocMainViewController: WebPolicyDelegate, WebFrameLoadDelegate {
    
    func webView(webView: WebView!, decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!, request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
        let navigationType = actionInformation[WebActionNavigationTypeKey] as! NSNumber
        guard case .LinkClicked = WebNavigationType(rawValue: navigationType.integerValue)! else {
            listener.use()
            return
        }
        guard let URL = actionInformation[WebActionOriginalURLKey] as? NSURL else {
            listener.use()
            return
        }
        
        listener.ignore()
        NSWorkspace.sharedWorkspace().openURL(URL)
    }
    
    func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!){
        // 恢复光标
        self.syncScroll();
    }
    
}
