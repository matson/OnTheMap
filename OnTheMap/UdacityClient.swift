//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/28/23.
//

import Foundation
import UIKit

class UdacityClient {
    
    struct Auth {
        
        static var sessionId = ""
        
    }
    
    enum Endpoints {
        
        static let baseUdacityAPI = "https://onthemap-api.udacity.com/v1"
        
        case createSessionId
        case logOut
        case getData(String)
        case getLocation
        case postLocation
        case updateLocation(String)
        
        var stringValue: String {
            
            switch self {
            case .createSessionId: return Endpoints.baseUdacityAPI + "/session"
            case .logOut: return Endpoints.baseUdacityAPI + "/session"
            case .getData(let userId): return Endpoints.baseUdacityAPI + "/users/" + userId
            case .getLocation: return Endpoints.baseUdacityAPI + "/StudentLocation?limit=100&order=-updatedAt"
            case .postLocation: return Endpoints.baseUdacityAPI + "/StudentLocation"
            case .updateLocation(let objectId): return Endpoints.baseUdacityAPI + "/StudentLocation/" + objectId
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, NetworkError?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, .connectionError)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, .invalidCredentials)
                }
            }
            
        }
        task.resume()
    }
    
    class func taskForPOSTRequestLocation<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    //PUT
    class func taskForPUTRequestLocation<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        print(url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    //GET
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    //GET
    class func taskForGETRequestNormal<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?, Bool) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error, false)
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ResponseType.self, from: data)
                completion(response, nil, true)
            } catch {
                completion(nil, error, false)
            }
        }
        task.resume()
        
        return task
    }
    
    
    //Posting a Session
    class func createSessionId(username: String, password: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let udacityCredentials = SessionRequest.UdacityCredentials(username: username, password: password)
        let body = SessionRequest(udacity: udacityCredentials)
        taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                UserSessionManager.shared.userKey = response.account.key
                completion(.success(true))
            } else {
                completion(.failure(error ?? .unknownError))
            }
        }
    }
    
    //Getting Public User Data
    class func getPublicUserData(userID: String, completion: @escaping (UserData?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getData(userID).url, responseType: UserData.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    //Deleting a Session
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logOut.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let range = 5..<data!.count
            let newData = data!.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(LogoutResponse.self, from: newData)
            } catch {
                print("error")
            }
            completion()
        }
        task.resume()
    }
    
    //Getting Student Locations
    class func getStudentLocation(completion: @escaping ([StudentLocation]?, Error?, Bool) -> Void) {
        taskForGETRequestNormal(url: Endpoints.getLocation.url, responseType: StudentInformationResponse.self) { response, error, success in
            if let response = response {
                if let studentInformationResponse = response as? StudentInformationResponse {
                    completion(studentInformationResponse.results, nil, true)
                } else {
                    completion(nil, error, false)
                }
            } else {
                completion(nil, error, false)
            }
        }
    }
    
    //Posting a Student Location
    class func postStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void){
        let studentLocation = PostStudentLocation(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        taskForPOSTRequestLocation(url: Endpoints.postLocation.url, responseType: PostLocationResponse.self, body: studentLocation) { response, error in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    
    //Putting a Student Location
    class func putStudentLocation(objectId: String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void){
        let studentLocation = PostStudentLocation(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        taskForPUTRequestLocation(url: Endpoints.updateLocation(objectId).url, responseType: UpdateLocationResponse.self, body: studentLocation) { response, error in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
        
    }
    
}


