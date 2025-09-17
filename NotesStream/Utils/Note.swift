//
//  Note.swift
//  NotesStream
//
//  Created by Soni Rusagara on 9/16/25.
//

import Foundation


/// Data model representing a note
/// Conforms to Codable for easy encoding/decoding from JSON
struct Note: Codable {
    let id: String
    let title: String
    let content: String
    let createdAt: String
    
    init(id: String, title: String, content: String, createdAt: String) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
}

extension Notification.Name {
    static let noteCreated = Notification.Name("noteCreated")
}

