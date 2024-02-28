//
//  Date.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 1.02.22.
//

import Foundation

extension Date {

    static func from(string: String?) -> Date? {

        guard let string = string else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        return dateFormatter.date(from: string)

    }

    var hour: String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: self)

    }

    var weekday: String {

        let index = Calendar.current.component(.weekday, from: self)
        let f = DateFormatter()

        guard index > 0 && index <= f.weekdaySymbols.count else {
            return ""
        }

        guard Calendar.current.isDateInToday(self) else {
            return f.weekdaySymbols[index - 1]
        }

        return "Today"

    }

}
