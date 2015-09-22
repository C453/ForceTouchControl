//
//  AppDelegate.swift
//  ForceTouchVolumeControl
//
//  Created by Case Wright on 9/21/15.
//  Copyright © 2015 C453. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let StatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        acquirePrivileges()
        //NSApplication.sharedApplication().windows.last!.close()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func acquirePrivileges() -> Bool {
        let accessEnabled:Bool = AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true])
        
        if !accessEnabled {
            print("You need to enable the keylogger in the System Prefrences")
        }
        return accessEnabled
    }
}

