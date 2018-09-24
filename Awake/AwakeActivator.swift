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

protocol AwakeActivatorDelegate {
    func awakeStatusChange()
}

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
    
    func activateFor(timeInterval: Double) {
        activate()
        if activeTimer != nil {
            activeTimer!.invalidate()
        }
        guard timeInterval != 0 else {
            return
        }

        activeTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { activeTimer in
            self.deactivate()
        }
    }
    
    func changeTimeInterval(timeInterval: Double) {
        // TODO: change timer
    }
    
    func deactivate() {
        guard status == .active else {
            return
        }
        guard IOPMAssertionRelease(assertionID) == kIOReturnSuccess else {
            print("Awake couldn't be deactivated!")
            return
        }
        status = .inactive
        print("Deactivated!")
        awakeActivatorDelegate?.awakeStatusChange()
    }
    
}
