//
//  Tools.swift
//  Stemma
//
//  Created by Michal Soukup on 29.03.2021.
//

import Foundation

func ShowName(name: String?, surname: String?) -> String {
    if name != nil && surname != nil {
        return "\(name!) \(surname!)"
    } else if name != nil {
        return "\(name!)"
    } else if surname != nil {
        return "\(surname!)"
    }
    return "Unknown"
}

func ShowDate(date: Date?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .none
    
    if date != nil {
        return dateFormatter.string(from: date!)
    }
    return "---"
}

func ShowBirthplace(place: String?, country: String?) -> String {
    if place != nil && country != nil {
        return "\(place!), \(country!)"
    } else if place != nil {
        return "\(place!)"
    } else if country != nil {
        return "\(country!)"
    }
    return "---"
}
