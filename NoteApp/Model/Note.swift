//
//  NoteModel.swift
//  NoteApp
//
//  Created by Robert on 18.04.25.
//

import SwiftUI

struct Note: Codable, Hashable, CustomStringConvertible {
    var id: String
    var title: String
    var description: String
    var isCompleted: Bool
    let creationDate: Date
    
    init(id: String,
         title: String,
         description: String,
         isCompleted: Bool
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.creationDate = Date()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
    }
    
    mutating func complete() {
        isCompleted.toggle()
    }
    
    mutating func update(_ newNote: Note) {
        self.title = newNote.title
        self.description = newNote.description
        self.isCompleted = newNote.isCompleted
    }
}
