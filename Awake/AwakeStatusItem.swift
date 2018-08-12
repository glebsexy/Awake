//
//  AwakeStatusItem.swift
//  Awake
//
//  Created by Gleb Sabirzyanov on 12/08/2018.
//  Copyright © 2018 Gleb Sabirzyanov. All rights reserved.
//

import Cocoa

private extension Selector {
    static let leftMouseDown = #selector(AwakeStatusItem.toggleAwake(_:))
    static let rightMouseDown = #selector(AwakeStatusItem.showMeMenu(_:))
}

protocol AwakeStatusItemDelegate {
    func toggleAwake()
    func showMenu()
}

class AwakeStatusItem: NSObject {
    fileprivate var delegate: AwakeStatusItemDelegate
    fileprivate var statusItem: NSStatusItem
    
    init(delegate: AwakeStatusItemDelegate, statusItem: NSStatusItem) {
        self.delegate = delegate
        self.statusItem = statusItem
        super.init()
        statusItem.highlightMode = false
        if let button = statusItem.button {
            button.target = self
            button.action = .leftMouseDown
        }
        showClosedStatusIcon()
    }
    
    func showClosedStatusIcon() {
        statusItem.button!.image = StatusIcon.closed.image
    }
    
    func showOpenStatusIcon() {
        statusItem.button!.image = StatusIcon.open.image
    }

}

// NSStatusBarButton methods
extension AwakeStatusItem {
    
    @objc func toggleAwake(_ sender: AnyObject!) {
        delegate.toggleAwake()
    }
    
    @objc func showMeMenu(_ sender: AnyObject!) {
        delegate.showMenu()
    }
    
}

extension NSStatusBarButton {
    override open func rightMouseDown(with theEvent: NSEvent) {
        _ = target!.perform(.rightMouseDown)
    }
}
