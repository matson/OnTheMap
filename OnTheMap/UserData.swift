//
//  UserData.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/29/23.
//

import Foundation

struct UserData: Codable {
    
    let firstName: String
    let email: Email
    let location: String?
    let lastName: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case email
        case location
        case lastName = "last_name"
    }
}

struct Email: Codable {
    let address: String
    //let verified: Bool
}
