//
//  Constants.swift
//  Awake
//
//  Created by Gleb Sabirzyanov on 23/09/2018.
//  Copyright © 2018 Gleb Sabirzyanov. All rights reserved.
//

import Foundation

struct TimeConstants {
    static let Intervals: [Double] = [10, 30, 60, 60*3, 60*8, 0]    //  In minutes
    static let IntervalsStrings: [String] = ["10 minutes", "30 minutes", "1 hour", "3 hours", "8 hours", "Indefinitely"]
    static let IntervalStorage = "TIME_INTERVAL"  //  Internal storage name
}
