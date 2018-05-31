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
    var prepareViewController: PrepareViewController?
    var switchViewController: SwitchViewController?
    var supportedViewController: SupportedViewController?
    var aboutWindowController: NSWindowController?
    
    let enableButton = NSMenuItem()
    let supportedAppsButton = NSMenuItem()
    let torController = TorController()
    let iconSize = 16
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // initialize view and window controllers
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        self.switchViewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SwitchVC")) as? SwitchViewController
        self.prepareViewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "PrepareVC")) as? PrepareViewController
        self.supportedViewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SupportedVC")) as? SupportedViewController
        self.aboutWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "AboutWC")) as? NSWindowController
        
        // create menu
        constructMenu()
        
        // set menu bar icon
        let icon = NSImage(named: NSImage.Name("AppIcon"))
        icon?.isTemplate = true // best for dark mode
        icon?.size = NSSize(width: iconSize, height: iconSize)
        statusItem.image = icon
        
        // download dependencies if needed
        DispatchQueue.global(qos: .background).async {
            self.torController.prepareDevice()
            DispatchQueue.main.async {
                self.enableButton.view = self.switchViewController?.view
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // restore user network settings
        self.torController.disableProxy()
    }
    
    @objc private func showAboutWindow() {
        if let controller = self.aboutWindowController {
            controller.showWindow(nil)
        }
    }
    
    @objc private func exit() {
        NSApplication.shared.terminate(self)
    }
    
    public func setProxy(toState state: NSControl.StateValue) {
        if state == NSControl.StateValue.on {
            self.torController.enableProxy()
        } else {
            self.torController.disableProxy()
        }
    }
    
    public func setSupportedAppsOnly(state: NSControl.StateValue) {
        if state == NSControl.StateValue.on {
            //
        } else {
            //
        }
    }
    
    private func constructMenu() {
        let menu = NSMenu()
        
        // add menu item to turn on/off VPN
        self.enableButton.view = self.prepareViewController?.view
        menu.addItem(self.enableButton)

        menu.addItem(NSMenuItem.separator())
        
        // add menu item to use circuit for special apps only
        self.supportedAppsButton.view = self.supportedViewController?.view
        menu.addItem(self.supportedAppsButton)
        
        menu.addItem(NSMenuItem.separator())
        
        // add button to show app info
        let aboutButton = NSMenuItem(title: "About", action: #selector(AppDelegate.showAboutWindow), keyEquivalent: "a")
        menu.addItem(aboutButton)
        
        menu.addItem(NSMenuItem.separator())
        
        // add quit button
        let quitButton = NSMenuItem(title: "Quit", action: #selector(AppDelegate.exit), keyEquivalent: "q")
        menu.addItem(quitButton)
        
        statusItem.menu = menu
    }
    
}

