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
    @IBOutlet weak var linksLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // display current app version and build number
        versionLabel.stringValue = self.getAppVersion()
        
        // make hyperlinks to dependency projects
        self.linksLabel!.allowsEditingTextAttributes = true
        let string = NSMutableAttributedString()
        string.append(self.createHyperlink(url: "https://www.torproject.org", name: "Tor project"))
        string.append(NSAttributedString(string: "\n"))
        string.append(self.createHyperlink(url: "https://brew.sh", name: "Homebrew"))
        self.linksLabel!.attributedStringValue = string
    }
    
    private func getAppVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return "Version: \(version)"
    }
    
    private func createHyperlink(url: String, name: String) -> NSAttributedString {
        let linkTextAttributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
            NSAttributedStringKey.foregroundColor: NSColor.blue,
            NSAttributedStringKey.link: url,
            NSAttributedStringKey.font: NSFont.systemFont(ofSize: 14.0)
        ]
        return NSAttributedString(string: name, attributes: linkTextAttributes)
    }
}
