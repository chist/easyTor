//
//  TorController.swift
//  easyTor
//
//  Created by Ivan Chistyakov on 5/27/18.
//  Copyright © 2018 Ivan Chistyakov. All rights reserved.
//

import Foundation

class TorController {
    let torProcess: Process? = nil
    
    // launch new process with given arguments and return stdOut and stdErr output
    private func exec(path: String, with args: [String]) -> (String, String) {
        let task = Process()
        
        task.launchPath = path
        task.arguments = args
        
        let errPipe = Pipe()
        task.standardError = errPipe
        let outPipe = Pipe()
        task.standardOutput = outPipe
        
        task.launch()
        
        // Get the data
        let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
        let out = String(decoding: outData, as: UTF8.self)
        let errData = errPipe.fileHandleForReading.readDataToEndOfFile()
        let err = String(decoding: errData, as: UTF8.self)
        
        return (out, err)
    }

    // download Homebrew if it isn't installed already
    private func installHomebrew() {
        let (_, error) = self.exec(path: "/usr/bin/env", with: ["brew"])
        
        if error.range(of: "brew: command not found") != nil {
            print("Installing homebrew...")
            let (_, _) = self.exec(path: "/usr/bin/ruby",
                                   with: ["-e", "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"])
            print("Homebrew is installed.")
        } else {
            print("Homebrew is already installed.")
        }
    }

    // download Tor if it isn't installed already
    private func installTor() {
        let (_, error) = self.exec(path: "/usr/bin/env", with: ["brew", "list", "tor"])
        
        if error.range(of: "No such keg:") != nil {
            print("Installing tor...")
            let (_, _) = self.exec(path: "/usr/bin/env", with: ["brew", "install", "tor"])
            print("Tor is installed.")
        } else {
            print("Tor is already installed.")
        }
    }
    
    // install all dependencies if needed
    private func prepareDevice() {
        self.installHomebrew()
        self.installTor()
    }

    public func enableProxy() {
        self.prepareDevice()
        let (_, _) = self.exec(path: "/usr/bin/env", with: ["tor"])
        print("Tor is launched.")

        let script = "do shell script \"networksetup -setsocksfirewallproxy Wi-Fi 127.0.0.1 9050\""
        let appleScript = NSAppleScript(source: script)
        let _ = appleScript?.executeAndReturnError(nil)
        print("Proxy is enabled.")
    }

    public func disableProxy() {
        let script = "do shell script \"networksetup -setsocksfirewallproxystate Wi-Fi off\""
        let appleScript = NSAppleScript(source: script)
        let _ = appleScript?.executeAndReturnError(nil)
        print("Proxy is disabled.")
    }

}

