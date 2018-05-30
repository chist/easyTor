//
//  SwitchViewController.swift
//  easyTor
//
//  Created by Ivan Chistyakov on 5/30/18.
//  Copyright © 2018 Ivan Chistyakov. All rights reserved.
//

import Foundation
import Cocoa

class SwitchViewController: NSViewController {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var enableVPNCheckBox: NSButton!
    
    @IBAction func enableVPNCheckBoxPressed(_ sender: Any) {
        appDelegate.setProxy(toState: enableVPNCheckBox.state)
    }
}
