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

class AwakeController {
    fileprivate var awakeControllerDelegate: AwakeControllerDelegate
    fileprivate var statusItem: AwakeStatusItem?
    fileprivate let awakeActivator = AwakeActivator()
    fileprivate var timeInterval: Double
    
    var isActive: Bool {
        return awakeActivator.status == .active
    }
    
    init(delegate: AwakeControllerDelegate, statusItem: NSStatusItem, timeIntervalIndex: Int) {
        self.awakeControllerDelegate = delegate
        self.timeInterval = TimeConstants.Intervals[timeIntervalIndex]
        self.statusItem = AwakeStatusItem(delegate: self, statusItem: statusItem)
        self.awakeActivator.setDelegate(self)
    }
    
    func shutdown() {
        awakeActivator.deactivate()
    }
    
    func setIntervalPreference(minutes: Double) {
        if minutes != timeInterval {
            timeInterval = minutes
            awakeActivator.changeTimeInterval(timeInterval: timeInterval)
        }
    }
    
    func setIntervalPreference(index: Int) {
        setIntervalPreference(minutes: TimeConstants.Intervals[index])
    }
    
}

extension AwakeController: AwakeActivatorDelegate {
    func awakeStatusChange() {
        if isActive {
            statusItem?.showOpenStatusIcon()
        } else {
            statusItem?.showClosedStatusIcon()
        }
    }
}

extension AwakeController: AwakeStatusItemDelegate {
    
    func toggleAwake() {
        // Icon is left-clicked
        if awakeActivator.status == .active {
            // If awake is currently active — turn it off
            awakeActivator.deactivate()
        } else {
            // Turn awake on otherwise
            awakeActivator.activateFor(timeInterval: timeInterval)
        }
    }
    
    func showMenu() {
        // Icon is right-clicked
        awakeControllerDelegate.showMenu()
    }
    
}
