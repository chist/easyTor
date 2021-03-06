//
//  TorController.swift
//  easyTor
//
//  Created by Ivan Chistyakov on 5/27/18.
//  Copyright © 2018 Ivan Chistyakov. All rights reserved.
//

import Foundation

enum shellError: Error {
    case fail
}

class TorController {
    private var torPID: Int?
    private let installBrewCommand = """
                             /usr/bin/ruby -e $(curl -fsSL
                             https://raw.githubusercontent.com/Homebrew/install/master/install)
                             """
    
    init() {
        // by default all traffic is transmited throught tor network
        self.setUpNetwork(state: false)
    }
    
    private func runShell(command: String) throws -> String? {
        let script = "do shell script \"" + command + "\""
        let appleScript = NSAppleScript(source: script)
        var error: NSDictionary?
        let output = appleScript?.executeAndReturnError(&error).stringValue
        if error != nil {
            print(error as Any)
            throw shellError.fail
        }
        return output
    }

    // download Homebrew if it isn't installed already
    private func installHomebrew() {
        do {
            _ = try runShell(command: "/usr/local/bin/brew list")
            print("Homebrew is already installed.")
        } catch {
            print("Installing homebrew...")
            do {
                _ = try self.runShell(command: self.installBrewCommand)
                print("Homebrew is installed.")
            } catch {
                print("Error during Homebrew installation")
            }
        }
    }

    // download Tor if it isn't installed already
    private func installTor() {
        do {
            let _ = try runShell(command: "/usr/local/bin/brew list tor")
            print("Tor is already installed.")
        } catch {
            print("Installing tor...")
            do {
                _ = try self.runShell(command: "/usr/local/bin/brew install tor")
                print("Tor is installed.")
            } catch {
                print("Error during tor installation.")
            }
        }
    }
    
    // install all dependencies if needed
    public func prepareDevice() {
        self.installHomebrew()
        self.installTor()
    }

    public func setUpNetwork(state: Bool) {
        if state {
            _ = try! self.runShell(command: "networksetup -setsocksfirewallproxy Wi-Fi 127.0.0.1 9050")
        } else {
            _ = try! self.runShell(command: "networksetup -setsocksfirewallproxystate Wi-Fi off")
        }
    }
    
    public func enableProxy() {
        // launch tor in background
        DispatchQueue.global(qos: .background).async {
            if let output = try? self.runShell(command: "/usr/local/bin/tor > /dev/null 2>&1 & echo $!") {
                DispatchQueue.main.async {
                    // save process identificator to kill it later
                    self.torPID = Int(output!)
                    
                    print("Proxy is enabled.")
                }
            }
        }
    }

    public func disableProxy() {
        // kill tor process
        if self.torPID != nil {
            _ = try? self.runShell(command: "kill -9 \(self.torPID!)")
            self.torPID = nil
        }
        
        // restore network settings
        self.setUpNetwork(state: false)

        print("Proxy is disabled.")
    }

}
