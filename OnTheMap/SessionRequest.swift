//
//  SessionRequest.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/28/23.
//

import Foundation

struct SessionRequest: Codable {
    
    let udacity: UdacityCredentials
        
        struct UdacityCredentials: Codable {
            let username: String
            let password: String
        }
}
