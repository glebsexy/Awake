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
    fileprivate var awakeController: AwakeController?
    
    @IBOutlet weak var menu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let selectedIndex = getSelectedTimeIndexSetting()
        awakeController = AwakeController(delegate: self, statusItem: statusItem, timeIntervalIndex: selectedIndex)
        setSelectedTime(index: selectedIndex)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        awakeController?.shutdown()
    }
    
    private func setMenuTitle() {
        let item = menu.item(withTag: 3)
        if awakeController?.isActive ?? false {
            item?.title = "Awake is active for"
        } else {
            item?.title = "Left click activates Awake for"
        }
    }
    
    private func setSelectedTime(index: Int) {
        for menuItem in menu.items {
            menuItem.state = .off
        }
        menu.item(withTitle: TimeConstants.IntervalsStrings[index])?.state = .on
    }
    
    private func getSelectedTimeIndexSetting() -> Int {
        return UserDefaults.standard.integer(forKey: TimeConstants.IntervalStorage)
    }
    
    private func writeSelectedTimeSetting(index: Int) {
        UserDefaults.standard.set(index, forKey: TimeConstants.IntervalStorage)
    }
    
    // Set Awake timer for the next several minutes
    @IBAction func selectTimeInterval(_ sender: NSMenuItem) {
        guard let index = TimeConstants.IntervalsStrings.lastIndex(of: sender.title) else {
            print("Time interval not found!")
            return
        }
        awakeController?.setIntervalPreference(index: index)
        setSelectedTime(index: index)
        writeSelectedTimeSetting(index: index)
    }
    
}

extension AppDelegate: AwakeControllerDelegate {
    func showMenu() {
        setMenuTitle()
        statusItem.popUpMenu(menu)
    }
}
