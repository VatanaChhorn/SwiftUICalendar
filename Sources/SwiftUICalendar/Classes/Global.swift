//
//  Global.swift
//  SwiftUICalendar
//
//  Created by GGJJack on 2021/10/22.
//

import Foundation
import SwiftUI

class Global {
    static let MAX_PAGE = 100
    static let CENTER_PAGE = 100 / 2
}

/// Configuration class for managing the global calendar used throughout SwiftUICalendar
/// 
/// This singleton allows you to set a specific calendar type (e.g., Gregorian) that will be used
/// across the entire SwiftUICalendar library, instead of relying on Calendar.current which may
/// vary based on the user's system settings.
///
/// See README.md for detailed usage examples and setup instructions.
public class CalendarConfig {
    private static var _shared = CalendarConfig()
    private var _calendar: Calendar = Calendar.current
    
    private init() {}
    
    /// Returns the singleton instance
    public static var shared: CalendarConfig {
        return _shared
    }
    
    /// Returns the currently configured calendar
    public var calendar: Calendar {
        return _calendar
    }
    
    /// Sets the global calendar to be used throughout the library
    /// - Parameter calendar: The calendar to use (e.g., Calendar(identifier: .gregorian))
    public func setCalendar(_ calendar: Calendar) {
        _calendar = calendar
    }
    
    /// Resets the calendar back to Calendar.current
    public func resetToDefault() {
        _calendar = Calendar.current
    }
}
