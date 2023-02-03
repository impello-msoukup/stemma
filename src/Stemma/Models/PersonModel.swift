//
//  PersonModel.swift
//  Stemma
//
//  Created by Michal Soukup on 27.03.2021.
//

import Foundation

enum Generation: Int {
    case Child, Parent, Grandparent
}

enum Gender: Int, Codable {
    case Male, Female
}

struct Person: Codable {
    var id: UUID?
    var gender: Gender?
    var name: String?
    var surname: String?
    var surnameAtBirth: String?
    var birthday: Date?
    var birthplace: String?
    var birthplaceCountry: String?
    var fatherId: UUID?
    var motherId: UUID?
    var died: Date?
    var portrait: Data?
}
