//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/28/23.
//

import Foundation

class UdacityClient {
    
    //Getting Student locations: https://onthemap-api.udacity.com/v1/StudentLocation
    
    struct Auth {
        
        static var sessionId = ""
        
    }
    
    enum Endpoints {
        
        static let baseUdacityAPI = "https://onthemap-api.udacity.com/v1"
        
        case createSessionId
        case logOut
        case getData(String)
        case getLocation
        
        var stringValue: String {
            
            switch self {
            case .createSessionId: return Endpoints.baseUdacityAPI + "/session"
            case .logOut: return Endpoints.baseUdacityAPI + "/session"
            case .getData(let userId): return Endpoints.baseUdacityAPI + "/users/" + userId
            case .getLocation: return Endpoints.baseUdacityAPI + "/StudentLocation"
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    //POST
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        //print(url) //not the url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        //print(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            //print("here past guard")
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                //print("here before try")
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                //print("got here to response Obj")
                //print(responseObject)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                //print("error here")
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
    
    //GET
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        //print(url)
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
                print(responseObject)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
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
        
        return task
    }
    
    //Posting a Session
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let udacityCredentials = SessionRequest.UdacityCredentials(username: username, password: password)
        let body = SessionRequest(udacity: udacityCredentials)
        taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                completion(true, nil)
            } else {
                completion(false, nil)
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
}
