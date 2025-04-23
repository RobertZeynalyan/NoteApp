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
    var isCompleted: Bool = false
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
    
    mutating func complete() {
        isCompleted.toggle()
    }
}
