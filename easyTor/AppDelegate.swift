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

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var switchViewController: SwitchViewController?
    var enableButton: NSMenuItem?
    let torController = TorController()
    let iconSize = 16
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // initialize switchViewController
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        self.switchViewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SwitchVC")) as? SwitchViewController
        
        // create menu
        constructMenu()
        
        // set menu bar icon
        let icon = NSImage(named: NSImage.Name("AppIcon"))
        icon?.isTemplate = true // best for dark mode
        icon?.size = NSSize(width: iconSize, height: iconSize)
        statusItem.image = icon
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    public func setProxy(toState state: NSControl.StateValue) {
        if state == NSControl.StateValue.on {
            self.torController.enableProxy()
        } else {
            self.torController.disableProxy()
        }
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        // add menu item to turn on/off VPN
        let switchButton = NSMenuItem()
        switchButton.view = self.switchViewController?.view
        menu.addItem(switchButton)
        
        statusItem.menu = menu
    }
    
}

