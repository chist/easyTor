//
//  AppDelegate.swift
//  easyTor
//
//  Created by Ivan Chistyakov on 5/27/18.
//  Copyright © 2018 Ivan Chistyakov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var enableButton: NSMenuItem?
    var state: Bool = false
    let torController = TorController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        constructMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func setProxy(_ sender: Any?) {
        if !self.state {
            self.torController.enableProxy()
            self.enableButton!.title = "Disable VPN"
            self.state = true
        } else {
            self.torController.disableProxy()
            self.enableButton!.title = "Enable VPN"
            self.state = false
        }
    }
    
    func constructMenu() {
        let menu = NSMenu()
        self.enableButton = NSMenuItem(title: "Enable VPN",
                                       action: #selector(AppDelegate.setProxy(_:)),
                                       keyEquivalent: "")
        menu.addItem(self.enableButton!)
        statusItem.menu = menu
    }
    
}

