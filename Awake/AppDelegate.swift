//
//  AppDelegate.swift
//  Awake
//
//  Created by Gleb Sabirzyanov on 12/08/2018.
//  Copyright © 2018 Gleb Sabirzyanov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    fileprivate let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    fileprivate var controller: AwakeController?
    
    @IBOutlet weak var menu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        controller = AwakeController(delegate: self, statusItem: statusItem)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // Removes previously set timer and turns off Awake
    @IBAction func removeTimer(_ sender: Any) {
        print("Remove timer!")
    }
    
    // Set Awake timer for the next several minutes
    @IBAction func awakeTimer1(_ sender: Any) {
        print("Set timer 1")
    }
    
}

extension AppDelegate: AwakeControllerDelegate {
    func showMenu() {
        statusItem.popUpMenu(menu)
    }
}
