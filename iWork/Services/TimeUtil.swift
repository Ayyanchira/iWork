//
//  TimeUtil.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/17/21.
//

import Foundation

class TimeUtil {
    static func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}
