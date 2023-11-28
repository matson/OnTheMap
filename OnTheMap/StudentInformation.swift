//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/27/23.
//

import Foundation


struct StudentInformation: Codable {
    
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    let createdAt: Date
    let updatedAt: Date
    //let ACL: AnyClass
    
    
}
