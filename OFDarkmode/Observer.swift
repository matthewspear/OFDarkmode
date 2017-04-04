//
//  Observer.swift
//  OFDarkMode
//
//  Created by Matthew Spear on 04/04/2017.
//  Copyright © 2017 Matthew Spear. All rights reserved.
//

import Foundation

class Observer: NSObject
{
    let distributedNC = DistributedNotificationCenter.default()
    
    var darkMode: Bool {
        return UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
    }
    
    override init() {
        super.init()
        
        distributedNC.addObserver(self, selector: #selector(darkModeChanged), name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
        darkModeChanged()
    }
    
    func darkModeChanged() {
        let id = "OFIColorPaletteIdentifier"
        let value = darkMode ? "builtin:OmniFocus Dark" : "default"
        
        var script = ""
        script.append("tell application \"OmniFocus\"\n")
        script.append("set value of preference id \"\(id)\" to \"\(value)\"\n")
        script.append("end tell\n")
        
        var error: NSDictionary?
        
        if let appleScript = NSAppleScript(source: script) {
            
            if let output = appleScript.executeAndReturnError(&error).stringValue {
                print("output: \(output)")
            }
            
            if let error = error {
                print("error: \(error)")
            }
        }
    }
}
