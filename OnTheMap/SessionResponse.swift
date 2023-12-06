//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/28/23.
//

import Foundation

struct SessionResponse: Codable {
    
    let account: Account
    let session: Session
    
    struct Account: Codable {
        let registered: Bool
        let key: String
    }
    
    struct Session: Codable {
        let id: String
        let expiration: String
    }
    
}


