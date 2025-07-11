//
//  Struct.swift
//  SwiftUICalendar
//
//  Created by GGJJack on 2021/10/21.
//

import Foundation
import SwiftUI

public enum Week: Int, CaseIterable {
    case sun = 0
    case mon = 1
    case tue = 2
    case wed = 3
    case thu = 4
    case fri = 5
    case sat = 6
    
    public var shortString: String {
        get {
            return DateFormatter().shortWeekdaySymbols[self.rawValue]
        }
    }
    
    public func shortString(locale: Locale) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        return formatter.shortWeekdaySymbols[self.rawValue]
    }
}

public enum Orientation {
    case horizontal
    case vertical
}

public enum HeaderSize {
    case zero
    case ratio
    case fixHeight(CGFloat)
}

public struct YearMonth: Equatable, Hashable {
    public let year: Int
    public let month: Int
    
    public init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }
    
    public static var current: YearMonth {
        get {
            let today = Date()
            let calendar = CalendarConfig.shared.calendar
            return YearMonth(year: calendar.component(.year, from: today), month: calendar.component(.month, from: today))
        }
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month
    }
    
    public var monthShortString: String {
        get {
            var components = toDateComponents()
            components.day = 1
            components.hour = 0
            components.minute = 0
            components.second = 0
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            return formatter.string(from: CalendarConfig.shared.calendar.date(from: components)!)
        }
    }
    
    public func addMonth(value: Int) -> YearMonth {
        let calendar = CalendarConfig.shared.calendar
        let toDate = self.toDateComponents()

        var components = DateComponents()
        components.month = value

        let addedDate = calendar.date(byAdding: components, to: calendar.date(from: toDate)!)!
        let ret = YearMonth(year: calendar.component(.year, from: addedDate), month: calendar.component(.month, from: addedDate))
        return ret
    }
    
    public func diffMonth(value: YearMonth) -> Int {
        var origin = self.toDateComponents()
        origin.day = 1
        origin.hour = 0
        origin.minute = 0
        origin.second = 0
        var new = value.toDateComponents()
        new.day = 1
        new.hour = 0
        new.minute = 0
        new.second = 0
        return CalendarConfig.shared.calendar.dateComponents([.month], from: CalendarConfig.shared.calendar.date(from: origin)!, to: CalendarConfig.shared.calendar.date(from: new)!).month!
    }
    
    public func toDateComponents() -> DateComponents {
        var components = DateComponents()
        components.year = self.year
        components.month = self.month
        return components
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.year)
        hasher.combine(self.month)
    }
    
    internal func cellToDate(_ cellIndex: Int, startWithMonday: Bool) -> YearMonthDay {
        let calendar = CalendarConfig.shared.calendar
        var toDateComponent = DateComponents()
        toDateComponent.year = self.year
        toDateComponent.month = self.month
        toDateComponent.day = 1
        let toDate = calendar.date(from: toDateComponent)!
        let weekday = calendar.component(.weekday, from: toDate)
        var components = DateComponents()
        components.day = cellIndex - weekday + (!startWithMonday ? 1 : weekday == 1 ? (-5) : 2)
        let addedDate = calendar.date(byAdding: components, to: toDate)!
        let year = calendar.component(.year, from: addedDate)
        let month = calendar.component(.month, from: addedDate)
        let day = calendar.component(.day, from: addedDate)
        let isFocusYaerMonth = year == self.year && month == self.month
        let ret = YearMonthDay(year: year, month: month, day: day, isFocusYearMonth: isFocusYaerMonth)
        return ret
    }
}

public struct YearMonthDay: Equatable, Hashable {
    public let year: Int
    public let month: Int
    public let day: Int
    public let isFocusYearMonth: Bool?
    
    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
        self.isFocusYearMonth = nil
    }
        
    public init(year: Int, month: Int, day: Int, isFocusYearMonth: Bool) {
        self.year = year
        self.month = month
        self.day = day
        self.isFocusYearMonth = isFocusYearMonth
    }
    
    public static var current: YearMonthDay {
        get {
            let today = Date()
            let calendar = CalendarConfig.shared.calendar
            return YearMonthDay(
                year: calendar.component(.year, from: today),
                month: calendar.component(.month, from: today),
                day: calendar.component(.day, from: today)
            )
        }
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
    
    public var isToday: Bool {
        let today = Date()
        let calendar = CalendarConfig.shared.calendar
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        return self.year == year && self.month == month && self.day == day
    }
    
    public var dayOfWeek: Week {
        let weekday = CalendarConfig.shared.calendar.component(.weekday, from: self.date!)
        return Week.allCases[weekday - 1]
    }
    
    public var date: Date? {
        let calendar = CalendarConfig.shared.calendar
        return calendar.date(from: self.toDateComponents())
    }
    
    public func toDateComponents() -> DateComponents {
        var components = DateComponents()
        components.year = self.year
        components.month = self.month
        components.day = self.day
        return components
    }
    
    public func addDay(value: Int) -> YearMonthDay {
        let calendar = CalendarConfig.shared.calendar
        let toDate = self.toDateComponents()

        var components = DateComponents()
        components.day = value

        let addedDate = calendar.date(byAdding: components, to: calendar.date(from: toDate)!)!
        let ret = YearMonthDay(
            year: calendar.component(.year, from: addedDate),
            month: calendar.component(.month, from: addedDate),
            day: calendar.component(.day, from: addedDate)
        )
        return ret
    }
    
    public func diffDay(value: YearMonthDay) -> Int {
        var origin = self.toDateComponents()
        origin.hour = 0
        origin.minute = 0
        origin.second = 0
        var new = value.toDateComponents()
        new.hour = 0
        new.minute = 0
        new.second = 0
        return CalendarConfig.shared.calendar.dateComponents([.day], from: CalendarConfig.shared.calendar.date(from: origin)!, to: CalendarConfig.shared.calendar.date(from: new)!).month!
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.year)
        hasher.combine(self.month)
        hasher.combine(self.day)
    }
}

