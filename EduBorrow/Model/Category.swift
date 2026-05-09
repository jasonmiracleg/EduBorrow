//
//  Category.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

enum Category: String, Codable, CaseIterable {
    case teaching = "Teaching"
    case networking = "Networking"
    case computerDevices = "Computer Devices"
    case audioVisual = "Audio Visual"
    case electronics = "Electronics"
    case other = "Other"
    
    var code: String {
        switch self {
        case .teaching:
            return "T"
        case .networking:
            return "N"
        case .computerDevices:
            return "CD"
        case .audioVisual:
            return "AV"
        case .electronics:
            return "E"
        case .other:
            return "O"
        }
    }
}
