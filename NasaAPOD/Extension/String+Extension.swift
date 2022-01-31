//
//  String+Extension.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 31/01/22.
//

import Foundation

extension String
{
    /// Format date to MMMM dd, yyyy
    var mdyformattedDate: String?
    {
        if let date = Date.init(dateString: self)
        {
            // MMMM dd, yyyy
            return date.dateFormatedString(ofStyle: .monthDateYear)
        }
        return nil
    }
    
    /// Format date to yyyy-mm-dd
    var ymdformattedDate: String?
    {
        if let date = Date.init(dateString: self)
        {
            // MMMM dd, yyyy
            return date.dateFormatedString(ofStyle: .yearMonthDate)
        }
        return nil
    }
}
