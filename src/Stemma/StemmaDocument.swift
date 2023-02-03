//
//  StemmaDocument.swift
//  Stemma
//
//  Created by Michal Soukup on 27.03.2021.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let stemmaDocument =
        UTType(exportedAs: "cz.impello.Stemma.structured-data")
}

struct StemmaDocument: FileDocument, Codable {
    var data: Document

    init(
        persons: [Person] = [],
        couples: [Couple] = []
    ) {
        self.data = Document(persons: persons, couples: couples)
    }

    static var readableContentTypes: [UTType] { [.stemmaDocument] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
          throw CocoaError(.fileReadCorruptFile)
        }
        self.data = try JSONDecoder().decode(Document.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self.data)
        return .init(regularFileWithContents: data)
    }
}
