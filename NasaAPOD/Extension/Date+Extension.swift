//
//  Date+Extension.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 31/01/22.
//

import Foundation

extension Date
{
    enum DateFormaterStyle: String
    {
        case monthDateYear = "MMMM dd, yyyy"
        case yearMonthDate = "yyyy-mm-dd"
        case militaryTimeformat = "dd MMM HH:mm"
    }
}

extension Date
{
    ///  Create date object from custom string.
    ///
    /// - Parameter custom string of format (yyyy-mm-dd).
    ///  // "CreateDate": "2022-01-28",
    init?(dateString: String, format: DateFormaterStyle = DateFormaterStyle.yearMonthDate)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format.rawValue
        if let date = dateFormatter.date(from: dateString) {
            self = date
        } else {
            return nil
        }
    }
}

extension Date
{
    /// Convert Date into string by using date formatter style.
    func dateFormatedString(ofStyle style: DateFormaterStyle = .militaryTimeformat) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = style.rawValue
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.timeZone = TimeZone.ReferenceType.system
        let convertedDateString =  formatter.string(from: self)
        return convertedDateString
    }
}
