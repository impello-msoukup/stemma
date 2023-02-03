//
//  DocumentModel.swift
//  Stemma
//
//  Created by Michal Soukup on 27.03.2021.
//

import Foundation

struct Document: Codable {
    var persons: [Person]
    var couples: [Couple]
}
