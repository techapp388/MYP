//
//  DateManager.swift
//  MyProHelper
//
//
//  Created by Ahmed Samir on 10/14/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import Foundation

struct DateManager {
    
    static func dateToString(date: Date?) -> String {
        guard let date = date else { return ""}
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DATE_FORMAT
        return formatter.string(from: date)
    }

    static func standardDateToStringWithoutHours(date: Date?) -> String {
        guard let date = date else { return ""}
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.STANDARD_DATE_WITHOUT_HOURS
        return formatter.string(from: date)
    }
    
    static func timeToString(date: Date?) -> String {
        guard let date = date else { return ""}
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.TIME_FORMAT
        return formatter.string(from: date)
    }
    
    static func timeFrameToString(date: Date?) -> String {
        guard let date = date else { return ""}
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.TIME_FRAME_FORMAT
        return formatter.string(from: date)
    }
    
    static func timeFrameStringToDate(time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.TIME_FRAME_FORMAT
        return formatter.date(from: time)
    }
    
    static func stringToDate(string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.STANDARD_DATE
        return formatter.date(from: string)
    }
    
    static func formatStandardToLocal(string: String) -> String {
        guard let date = stringToDate(string: string) else {
            return ""
        }
        return dateToString(date: date)
    }
    
    static func formatStandardTimeString(string: String) -> String {
        guard let date = stringToDate(string: string) else {
            return ""
        }
        return timeToString(date: date)
    }
    
    static func getStandardDateString(date: Date?) -> String {
        guard let date = date else { return ""}
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.STANDARD_DATE
        return formatter.string(from: date)
    }
    
    static func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func roundDate(date: Date, minutesInterval: Int) -> Date? {
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        
        if minutes < minutesInterval {
            return calendar.date(byAdding: .minute, value: -minutes, to: date)
        }
        else {
            let nextDiff = minutesInterval - minutes
            return calendar.date(byAdding: .minute, value: nextDiff, to: date)
        }
    }
}
