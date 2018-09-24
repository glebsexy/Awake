//
//  AwakeActivator.swift
//  Awake
//
//  Created by Gleb Sabirzyanov on 23/09/2018.
//  Copyright © 2018 Gleb Sabirzyanov. All rights reserved.
//

import Foundation
import IOKit.pwr_mgt

enum AwakeStatus {
    case active
    case inactive
}

/// Callback on the Awake session lifecycle events.
protocol AwakeActivatorDelegate {
    func awakeStatusChange()
}

/// The class responsible for the Awake session lifecycle. Handles the activation, deactivation and all changes of the session.
class AwakeActivator {
    fileprivate let reasonForActivity = "Mac stays Awake"
    fileprivate var assertionID: IOPMAssertionID = IOPMAssertionID(0)
    fileprivate var activeTimer: Timer? = nil
    var status: AwakeStatus = .inactive
    fileprivate var awakeActivatorDelegate: AwakeActivatorDelegate? = nil
    
    public func setDelegate(_ delegate: AwakeActivatorDelegate) {
        self.awakeActivatorDelegate = delegate
    }
    
    fileprivate func createAssertion() -> IOReturn {
        let type = kIOPMAssertPreventUserIdleDisplaySleep
        let level = IOPMAssertionLevel(kIOPMAssertionLevelOn)
        return IOPMAssertionCreateWithName(type as CFString?, level, reasonForActivity as CFString?, &assertionID)
    }
    
    /// Activates a new Awake session.
    func activate() {
        deactivate()
        guard createAssertion() == kIOReturnSuccess else {
            print("Awake couldn't be activated!")
            return
        }
        status = .active
        print("Activated!")
        awakeActivatorDelegate?.awakeStatusChange()
    }
    
    
    /// Activates the timer for a specified amount of time.
    ///
    /// - Parameter timeInterval: time interval in minutes
    func activateFor(minutes: Double) {
        activate()
        if activeTimer != nil {
            activeTimer!.invalidate()
        }
        guard minutes != 0 else {
            return
        }

        activeTimer = Timer.scheduledTimer(withTimeInterval: minutes, repeats: false) { activeTimer in
            self.deactivate()
        }
    }
    
    
    /// Changes current time interval setting to a new one.
    ///
    /// - Parameter timeInterval: new time interval in minutes
    func changeTimeInterval(minutes: Double) {
        // TODO: change timer
    }
    
    /// Deactivates the currently active Awake session.
    func deactivate() {
        guard status == .active else {
            return
        }
        guard IOPMAssertionRelease(assertionID) == kIOReturnSuccess else {
            print("Awake couldn't be deactivated!")
            return
        }
        status = .inactive
        activeTimer?.invalidate()
        print("Deactivated!")
        awakeActivatorDelegate?.awakeStatusChange()
    }
    
}
