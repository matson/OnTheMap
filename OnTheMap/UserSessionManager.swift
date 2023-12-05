//
//  UserSessionManager.swift
//  OnTheMap
//
//  Created by Tracy Adams on 12/4/23.
//

import Foundation

class UserSessionManager {
    
    static let shared = UserSessionManager()
    var userKey: String?
    
    private init() {}
}
