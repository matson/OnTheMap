//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/28/23.
//

import Foundation

class UdacityClient {
    
    //need a session ID to login
    //Links:
    //session: https://onthemap-api.udacity.com/v1/session
    //delete: https://onthemap-api.udacity.com/v1/session
    
    struct Auth {
        
        static var sessionId = ""
        
    }
    
    enum Endpoints {
        
        static let baseUdacityAPI = "https://onthemap-api.udacity.com"
        
        case createSessionId
        
        var stringValue: String {
            
            switch self {
            case .createSessionId: return Endpoints.baseUdacityAPI + "/v1/session"
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    //POST
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        print(url) //not the url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        print(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            print("here past guard")
            let decoder = JSONDecoder()
            do {
                print("here before try")
                let responseObject = try decoder.decode(SessionResponse.self, from: data)
                print("got here to response Obj")
                print(responseObject)
//                DispatchQueue.main.async {
//                    completion(responseObject, nil)
//                }
            } catch {
                print("error here")
                do {
                    let errorResponse = try decoder.decode(SessionResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let udacityCredentials = SessionRequest.UdacityCredentials(username: username, password: password)
        let body = SessionRequest(udacity: udacityCredentials)
        taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body) { response, error in
            if let response = response {
                print("I'm here in the response")
                //assuming the response id is the same?
                Auth.sessionId = response.session.id
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
}
