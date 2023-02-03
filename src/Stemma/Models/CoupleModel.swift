//
//  CoupleModel.swift
//  Stemma
//
//  Created by Michal Soukup on 27.03.2021.
//

import Foundation

struct Couple: Codable {
    var man: UUID
    var woman: UUID
    var married: Bool
    var date: Date?
    var place: String?
}
