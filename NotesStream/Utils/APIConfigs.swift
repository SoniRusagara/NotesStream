//
//  APIConfigs.swift
//  NotesStream
//
//  Created by Soni Rusagara on 8/4/25.
//

import Foundation

class APIConfigs{
    // API base URLs
    // TODO: Update with mock service apis
    static let baseAuthURL = "http://apis.sakibnm.work:3000/api/auth/"
    static let baseNotesURL = " http://apis.sakibnm.work:3000/api/note"
    
    // Auth Endpoints
    static var register: String {return baseAuthURL + "register"}
    static var login: String {return baseAuthURL + "login"}
    static var logout: String {return baseAuthURL + "logout"}
    static var me: String {return baseAuthURL + "me"}
    
    // Notes Endpoints
    static var getAllNotes: String { return baseNotesURL + "getall"}
    static var addNote: String { return baseNotesURL + "post"}
    static var deleteNotes: String { return baseNotesURL + "delete"}
}
