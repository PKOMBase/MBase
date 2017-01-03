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
    
//    func webView(_ webView: WebView!, decidePolicyForNavigationAction actionInformation: [AnyHashable: Any]!, request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
//        let navigationType = actionInformation[WebActionNavigationTypeKey] as! NSNumber
//        guard case .linkClicked = WebNavigationType(rawValue: navigationType.intValue)! else {
//            listener.use()
//            return
//        }
//        guard let URL = actionInformation[WebActionOriginalURLKey] as? URL else {
//            listener.use()
//            return
//        }
//        
//        listener.ignore()
//        NSWorkspace.shared().open(URL)
//    }
    
    func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!){
        // 恢复光标
        self.syncScroll();
    }
    
}
