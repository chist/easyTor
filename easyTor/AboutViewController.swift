//
//  AboutViewController.swift
//  easyTor
//
//  Created by Ivan Chistyakov on 5/31/18.
//  Copyright © 2018 Ivan Chistyakov. All rights reserved.
//

import Foundation
import Cocoa

class AboutViewController: NSViewController {
    
    @IBOutlet weak var versionLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // display current app version and build number
        versionLabel.stringValue = self.getAppVersion()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // place app window into focus
        self.view.window?.makeKey()
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func getAppVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return "Version: \(version)"
    }
}
