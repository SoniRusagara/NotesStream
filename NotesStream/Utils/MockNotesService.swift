//
//  MockNotesService.swift
//  NotesStream
//
//  Created by Soni Rusagara on 8/7/25.
//

import Foundation

/// Data model representing a note
/// Conforms to Codable for easy encoding/decoding from JSON
struct Note: Codable {
    let id: String
    let title: String
    let content: String
    let createdAt: String
}


/// Service class to simulate fetching notes data (mock API)
class MockNotesService{
    /// Singleton instance of the mock service
    static let shared = MockNotesService()
    
    /// Private init to enforce singleton pattern
    private init() {}
    
    /// Simulates an API call to fetch notes with fake data
    /// Adds a 1-second delay to mimic real-world latency
    func fetchNotes(completion: @escaping ([Note]) -> Void) {
        let sampleNotes = [
            Note(id: "1", title: "Welcome Note", content: "My first note!! Woohoo 🎉", createdAt: "8/1/25"),
            Note(id: "2", title: "Research Thoughts", content: "Reminder to follow up on paper edits and experiments.", createdAt: "8/3/25"),
            Note(id: "3", title: "CS Conference", content: "Add presentation slides & feedback summary", createdAt: "8/7/25")
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(sampleNotes)
        }
    }
}
