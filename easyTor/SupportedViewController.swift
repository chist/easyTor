//
//  SupportedViewController.swift
//  easyTor
//
//  Created by Ivan Chistyakov on 5/31/18.
//  Copyright © 2018 Ivan Chistyakov. All rights reserved.
//

import Foundation
import Cocoa

class SupportedViewController: NSViewController {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var supportedAppsCheckBox: NSButton!
    
    @IBAction func supportedAppsCheckBoxPressed(_ sender: Any) {
        appDelegate.setSupportedAppsOnly(state: self.supportedAppsCheckBox.state)
    }

}
