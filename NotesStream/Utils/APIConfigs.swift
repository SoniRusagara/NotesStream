//
//  APIConfigs.swift
//  NotesStream
//
//  Created by Soni Rusagara on 8/4/25.
//

import Foundation

class APIConfigs {
    // === Base URLs ===
    // HTTP API Invoke URL (stage = $default → no stage segment in the path)
    static let baseGatewayURL = "https://mj959f6cve.execute-api.eu-north-1.amazonaws.com"

    // Notes base (trailing slash so we can append endpoints without leading slash)
    static let baseNotesURL = baseGatewayURL + "/api/note/"

    // when stand up auth on API Gateway, flip this to your /api/auth/ base.
    // For now leaving it pointing to Postman (or comment it out if unused).
    static let baseAuthURL = "https://d25172d9-9593-4b59-886f-25257f2e89e4.mock.pstmn.io/api/auth/"

    // === Auth Endpoints (optional until you wire AWS auth) ===
    static var register: String { baseAuthURL + "register" }
    static var login:    String { baseAuthURL + "login" }
    static var logout:   String { baseAuthURL + "logout" }
    static var me:       String { baseAuthURL + "me" }

    // === Notes Endpoints (live on API Gateway) ===
    static var getAllNotes: String { baseNotesURL + "getall" }
    static var addNote:     String { baseNotesURL + "post" }
    static var deleteNotes: String { baseNotesURL + "delete" }
}

