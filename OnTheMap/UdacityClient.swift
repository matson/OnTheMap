//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/28/23.
//

import Foundation

class UdacityClient {
    //https://onthemap-api.udacity.com/v1/StudentLocation/<objectId>
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
            case .getLocation: return Endpoints.baseUdacityAPI + "/StudentLocation?limit=100"
            case .postLocation: return Endpoints.baseUdacityAPI + "/StudentLocation"
            case .updateLocation(let objectId): return Endpoints.baseUdacityAPI + "/StudentLocation/" + objectId
                
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
            print("here before decoding")
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                print(responseObject)
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
        print(url)
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
    
    //GET
    class func taskForGETRequestNormal<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping ([ResponseType]?, Error?) -> Void) -> URLSessionDataTask {
        //print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            //let responseObject = try decoder.decode([String: [ResponseType]].self, from: data)
            //print("We here")
            let decoder = JSONDecoder()
            do {
//                if let responseValue = responseObject.values.first?.first {
//                                DispatchQueue.main.async {
//                                    completion(responseValue, nil)
//                                }
//                            } else {
//                                DispatchQueue.main.async {
//                                    completion(nil, error)
//                                }
//                            }
                //let responseObject = try decoder.decode([String: [ResponseType]].self, from: data)
                let responseObject = try decoder.decode([ResponseType].self, from: data)
                print(responseObject)
                do{
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            } catch {
                //print("HERE OPPS")
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
    
    //Getting Student Locations
    class func getStudentLocation(completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        taskForGETRequestNormal(url: Endpoints.getLocation.url, responseType: StudentLocation.self) { response, error in
            if let response = response {
                print("i got here!")
                completion(response, nil)
            } else {
                completion(nil, error)
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
