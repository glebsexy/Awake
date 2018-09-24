//
//  AwakeController.swift
//  Awake
//
//  Created by Gleb Sabirzyanov on 12/08/2018.
//  Copyright © 2018 Gleb Sabirzyanov. All rights reserved.
//

import Cocoa

protocol AwakeControllerDelegate {
    func showMenu()
}

/// Responsible for the main application actions control. Main control coordination node.
class AwakeController {
    fileprivate var awakeControllerDelegate: AwakeControllerDelegate
    fileprivate var statusItem: AwakeStatusItem?
    fileprivate let awakeActivator = AwakeActivator()
    fileprivate var timeInterval: Double
    
    var isActive: Bool {
        return awakeActivator.status == .active
    }
    
    /// Initialize a new AwakeController.
    ///
    /// - Parameters:
    ///   - delegate: AwakeControllerDelegate to send callbacks to.
    ///   - statusItem: NSStatusItem which is the main app component.
    ///   - timeIntervalIndex: The index of the currently selected time interval.
    init(delegate: AwakeControllerDelegate, statusItem: NSStatusItem, timeIntervalIndex: Int) {
        self.awakeControllerDelegate = delegate
        self.timeInterval = TimeConstants.Intervals[timeIntervalIndex]
        self.statusItem = AwakeStatusItem(delegate: self, statusItem: statusItem)
        self.awakeActivator.setDelegate(self)
    }
    
    /// Executed before the app quit.
    func shutdown() {
        awakeActivator.deactivate()
    }
    
    /// Sets the new time interval preference to set the timer with later on
    ///
    /// - Parameter minutes: new time interval in minutes
    func setIntervalPreference(minutes: Double) {
        if minutes != timeInterval {
            timeInterval = minutes
            awakeActivator.changeTimeInterval(minutes: timeInterval)
        }
    }
    
    /// Sets the time interval based on the index of it in the list.
    ///
    /// - Parameter index: index of the time interval in the Intervals constant list.
    func setIntervalPreference(index: Int) {
        setIntervalPreference(minutes: TimeConstants.Intervals[index])
    }
    
}

extension AwakeController: AwakeActivatorDelegate {
    
    /// The status of the Awake session has changed.
    func awakeStatusChange() {
        if isActive {
            statusItem?.showOpenStatusIcon()
        } else {
            statusItem?.showClosedStatusIcon()
        }
    }
}

extension AwakeController: AwakeStatusItemDelegate {
    
    /// Toggles the status of the Awake when the icon is left-clicked
    func toggleAwake() {
        if awakeActivator.status == .active {
            // If awake is currently active — turn it off
            awakeActivator.deactivate()
        } else {
            // Turn awake on otherwise
            awakeActivator.activateFor(minutes: timeInterval)
        }
    }
    
    /// The icon is right-clicked; show menu
    func showMenu() {
        awakeControllerDelegate.showMenu()
    }
    
}
