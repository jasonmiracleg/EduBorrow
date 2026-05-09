//
// ValidationService.swift
// EduBorrow
//

import Foundation

final class ValidationService {

    /// Validate a date string against a date format (e.g. "yyyy-MM-dd HH:mm")
    /// Returns true if the string can be parsed using the provided format and represents a valid date.
    func isValidDateString(_ string: String, format: String) -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format

        return formatter.date(from: string) != nil
    }
}
