//
//  AlertUtils.swift
//  MBase
//
//  Created by sunjie on 16/9/15.
//  Copyright © 2016年 popkidorc. All rights reserved.
//

import Cocoa

class AlertUtils: NSObject {
    
    typealias buttonEvent = () ->()

    static func alert(title: String, content: String, buttons: [String], buttonEvents: [buttonEvent]) {
        if buttons.count > 3 {
            return;
        }
        let alert = NSAlert();
        for button in buttons {
            alert.addButtonWithTitle(button);
        }
        alert.messageText = title;
        alert.informativeText = content;
        let modal = alert.runModal();
        switch modal {
        case NSAlertFirstButtonReturn:
            buttonEvents[0]();
            break;
        case NSAlertSecondButtonReturn:
            buttonEvents[1]();
        break;
        case NSAlertThirdButtonReturn:
            buttonEvents[2]();
        default:
            return;
        }
    }
}
