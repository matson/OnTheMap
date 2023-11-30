//
//  PostStudentLocation.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/29/23.
//

import Foundation

struct PostStudentLocation: Codable {
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
}
