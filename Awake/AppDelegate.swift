//
//  AppDelegate.swift
//  Awake
//
//  Created by Gleb Sabirzyanov on 12/08/2018.
//  Copyright © 2018 Gleb Sabirzyanov. All rights reserved.
//

import Cocoa

/// You don't have to think to understand that this where the app lifecycle happens.
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    fileprivate let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    fileprivate var awakeController: AwakeController?
    
    @IBOutlet weak var menu: NSMenu!
    
    /// That's easy to understand that this method is executed when the app starts
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let selectedIndex = getSelectedTimeIndexSetting()
        awakeController = AwakeController(delegate: self, statusItem: statusItem, timeIntervalIndex: selectedIndex)
        setSelectedTime(index: selectedIndex)
    }
    
    /// The app wants to quit, turn all things off fast AF!
    func applicationWillTerminate(_ aNotification: Notification) {
        awakeController?.shutdown()
    }
    
    /// Set the title of the main menu depending on wether Awake is active or not
    private func setMenuTitle() {
        let item = menu.item(withTag: 3)
        if awakeController?.isActive ?? false {
            item?.title = "Awake is active for"
        } else {
            item?.title = "Left click activates Awake for"
        }
    }
    
    /// Put a checkmark next to the right menu item to show it's selected.
    ///
    /// - Parameter index: the index of the item that needs to be selected.
    private func setSelectedTime(index: Int) {
        for menuItem in menu.items {
            menuItem.state = .off
        }
        menu.item(withTitle: TimeConstants.IntervalsStrings[index])?.state = .on
    }
    
    /// Find the index of the previously selected time. A method with a very long name.
    ///
    /// - Returns: index of the previously selected time from the internal storage.
    private func getSelectedTimeIndexSetting() -> Int {
        return UserDefaults.standard.integer(forKey: TimeConstants.IntervalStorage)
    }
    
    /// Write the newly selected time to the internal storage.
    ///
    /// - Parameter index: index of the currently selected time to be written.
    private func writeSelectedTimeSetting(index: Int) {
        UserDefaults.standard.set(index, forKey: TimeConstants.IntervalStorage)
    }
    
    /// The time interval is selected, act upon!
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
