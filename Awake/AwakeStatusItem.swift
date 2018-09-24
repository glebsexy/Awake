//
//  AwakeStatusItem.swift
//  Awake
//
//  Created by Gleb Sabirzyanov on 12/08/2018.
//  Copyright © 2018 Gleb Sabirzyanov. All rights reserved.
//

import Cocoa

protocol AwakeStatusItemDelegate {
    func toggleAwake()
    func showMenu()
}

/// Controls the behaviour of the status item and interactions with it.
class AwakeStatusItem: NSObject {
    fileprivate let statusItemDelegate: AwakeStatusItemDelegate
    fileprivate let statusItem: NSStatusItem
    
    /// Initialize the new AwakeStatusItem.
    ///
    /// - Parameters:
    ///   - delegate: AwakeStatusItemDelegate to send callbacks to.
    ///   - statusItem: the main status item of the app.
    init(delegate: AwakeStatusItemDelegate, statusItem: NSStatusItem) {
        self.statusItemDelegate = delegate
        self.statusItem = statusItem
        super.init()
        statusItem.highlightMode = false
        
        // Make button send actions to this AwakeStatusItem
        if let button = statusItem.button {
            button.target = self
            button.action = #selector(self.statusBarButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        showClosedStatusIcon()
    }
    
    /// Awake is Inactive
    func showClosedStatusIcon() {
        statusItem.button!.image = StatusIcon.closed.image
    }
    
    /// Awake is Active
    func showOpenStatusIcon() {
        statusItem.button!.image = StatusIcon.open.image
    }

    /// NSStatusBarButton has been clicked
    ///
    /// - Parameter sender: NSStatusBarButton that sends the click event
    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
            // Show menu on the right click
            statusItemDelegate.showMenu()
        } else {
            // Toggle awake on the left click
            statusItemDelegate.toggleAwake()
        }
    }

}
