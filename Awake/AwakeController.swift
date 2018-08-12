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
    fileprivate var delegate: AwakeControllerDelegate
    fileprivate var statusItem: AwakeStatusItem?
    
    init(delegate: AwakeControllerDelegate, statusItem: NSStatusItem) {
        self.delegate = delegate
        self.statusItem = AwakeStatusItem(delegate: self, statusItem: statusItem)
    }
    
}

extension AwakeController: AwakeStatusItemDelegate {
    
    func toggleAwake() {
        print("Toggle awake!")
    }
    
    func showMenu() {
        delegate.showMenu()
    }
    
}
