//
//  StatusIcon.swift
//  Awake
//
//  Created by Gleb Sabirzyanov on 12/08/2018.
//  Copyright © 2018 Gleb Sabirzyanov. All rights reserved.
//

import Cocoa

enum StatusIcon: String {
    case open = "EyeOpen"
    case closed = "EyeClosed"
    
    fileprivate var named: NSImage.Name {
        return NSImage.Name(rawValue: self.rawValue)
    }
    
    var image: NSImage {
        guard let image = NSImage(named: named) else {
            fatalError()
        }
        return image
    }
}
