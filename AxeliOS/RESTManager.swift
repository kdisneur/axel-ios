//
//  RESTManager.swift
//  AxeliOS
//
//  Created by Kevin Disneur on 08/10/16.
//  Copyright © 2016 Kevin Disneur. All rights reserved.
//

import Foundation

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    func addBabyBottle(_ quantity: Int, at datetime: Date, onCompletion: @escaping (Any) -> Void, onError: @escaping (String) -> Void) {
        postToAPI("/baby_bottles",
                  params: ["fed_at": formatDatetime(datetime), "quantity": quantity],
                  onCompletion: onCompletion,
                  onError: onError)
    }
    
    func addDiaper(_ datetime: Date, withPoop poop: Bool, AndPee pee: Bool, onCompletion: @escaping (Any) -> Void, onError: @escaping (String) -> Void) {
        postToAPI("/diapers",
                  params: ["changed_at": formatDatetime(datetime), "poop": poop, "pee": pee],
                  onCompletion: onCompletion,
                  onError: onError)
    }
    
    func loadDailyStats(_ datetime: Date, onCompletion: @escaping (Any) -> Void, onError: @escaping (String) -> Void) {
        getFromAPI("/stats/daily_consumption/\(formatDate(datetime))", params: [:], onCompletion: onCompletion, onError: onError)
    }
    
    func loadHistory(_ date: Date, onCompletion: @escaping (Any) -> Void, onError: @escaping (String) -> Void) {
        getFromAPI("/history/daily/\(formatDate(date))", params: [:], onCompletion: onCompletion, onError: onError)
    }
    
    func remove(_ event: Event, onCompletion: @escaping (Any) -> Void, onError: @escaping (String) -> Void) {
        switch event.type {
        case .feeding:
            deleteOnAPI("/baby_bottles/\(event.id)", onCompletion: onCompletion, onError: onError)
        case .change:
            deleteOnAPI("/diapers/\(event.id)", onCompletion: onCompletion, onError: onError)
        }
    }
    
    func formatDatetime(_ datetime: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: datetime)
    }
    
    func formatDate(_ datetime: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: datetime)
    }
    
    func deleteOnAPI(_ path: String, onCompletion: @escaping (Any) -> Void, onError: @escaping (String) -> Void) {
        doWithAPI(path, method: "DELETE", params: [:], onCompletion: onCompletion, onError: onError)
    }
    
    func getFromAPI(_ path: String, params: [String : Any], onCompletion: @escaping (Any) -> Void, onError: @escaping (String) -> Void) {
        doWithAPI(path, method: "GET", params: nil, onCompletion: onCompletion, onError: onError)
    }
    
    func postToAPI(_ path: String, params: [String : Any], onCompletion: @escaping (Any) -> Void, onError: @escaping (String) -> Void) {
        doWithAPI(path, method: "POST", params: params, onCompletion: onCompletion, onError: onError)
    }
    
    func doWithAPI(_ path: String, method: String, params: [String : Any]?, onCompletion: @escaping (Any) -> Void, onError: @escaping (String) -> Void) {
        let username = UserDefaults.standard.value(forKey: "login") as! String
        let password = UserDefaults.standard.value(forKey: "password") as! String
        let authentication = "\(username):\(password)".data(using: String.Encoding.utf8)?.base64EncodedString()
        let baseURL = UserDefaults.standard.value(forKey: "api_base_url") as! String
        
        var request = URLRequest.init(url: URL.init(string: baseURL + path)!)
        let session = URLSession.shared
        request.httpMethod = method
        
        do {
            if params != nil {
                try request.httpBody = JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Basic \(authentication!)", forHTTPHeaderField: "Authorization")
            
            let dataTask = session.dataTask(with: request,
                                            completionHandler: {data, response, error -> Void in
                                                if error != nil || data == nil {
                                                    DispatchQueue.main.async { onError("Error on API call") }
                                                    return
                                                }
                                                
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!,
                                                                                                options: JSONSerialization.ReadingOptions.mutableLeaves)

                                                    DispatchQueue.main.async { onCompletion(json) }
                                                } catch {
                                                    DispatchQueue.main.async { onError("JSON parsing failure") }
                                                }
            })
            
            dataTask.resume()
        } catch {
            DispatchQueue.main.async { onError("JSON creation failure") }
            return
        }
    }
}
