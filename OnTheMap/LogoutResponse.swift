//
//  LogoutResponse.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/29/23.
//

import Foundation

struct LogoutResponse: Codable {
    
    struct DeleteResponse: Codable {
        let session: Session
    }

    struct Session: Codable {
        let id: String
        let expiration: String
    }
}
