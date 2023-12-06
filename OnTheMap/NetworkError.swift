//
//  NetworkError.swift
//  OnTheMap
//
//  Created by Tracy Adams on 12/6/23.
//

import Foundation


struct NetworkError: Error {
    let errorMessage: String
    
    static let connectionError = NetworkError(errorMessage: "Failed to connect to the server.")
    static let invalidCredentials = NetworkError(errorMessage: "Invalid credentials.")
    static let unknownError = NetworkError(errorMessage: "unknown error")
    // Add more cases as needed
    
    init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
