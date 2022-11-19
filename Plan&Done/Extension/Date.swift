//
//  Date.swift
//  Plan&Done
//
//  Created by Alexander Senin on 19.11.2022.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
