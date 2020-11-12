//
//  NetworkManager.swift
//  InterviewTask
//
//  Created by HAPPY on 11/12/20.
//

import Foundation
import UIKit

class NetworkManager {
    static let BASE_URL = "https://raw.githubusercontent.com/vega/vega/master/"
    private static let timeOutIntervalForRequest = 30.0
    private static let timeOutIntervalForResource = 30.0
    
    fileprivate enum CachePolicy : String {
        case networkOnly           = "Network Only"
        case cacheOnly             = "Cache Only"
        case cacheElseNetwork      = "Cache Else Network"
        case networkElseCache      = "Network Else Cache"
        case reloadRevalidateCache = "Reload Revalidate Cache Data"
    }
    
    fileprivate enum HTTPMethod : String {
        case get     = "GET"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
    }
    
    fileprivate enum Result<String>{
        case success
        case failure(String)
    }

    fileprivate class func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.authenticationError.rawValue)
        }
    }
    
    
    fileprivate class func getSession() -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeOutIntervalForRequest
        sessionConfig.timeoutIntervalForResource = timeOutIntervalForResource
        let session = URLSession(configuration: sessionConfig)
        return session
    }
    
    
    fileprivate class func processResponse(data: Data?, response: URLResponse?, responseError: Error?, completion: @escaping ([[String: Any]]?) -> ()) {
        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
        
        guard responseError == nil else {
            completion([["message": responseError?.localizedDescription ?? ""]])
            return
        }
        
        guard let responseData = data else {
            completion([["message": NetworkResponse.noData.rawValue]])
            return
        }
        
        guard let json = (try? JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [[String: Any]] else {
            print("Not containing JSON")
            return
        }
        
        completion(json)
    }
    
   
    
    //MARK:- Network Calls
    // Netwrok Call with URL Sessions
    fileprivate class func fetchGenericData(urlString: String, paramsBag: NSDictionary? = nil, cachePolicy: CachePolicy = CachePolicy.networkOnly, completion: @escaping ([[String: Any]]?) -> ()) {
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            guard let url = URL(string: urlString) else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            var headers = request.allHTTPHeaderFields ?? [:]
            headers["Content-Type"] = "application/json"
            request.allHTTPHeaderFields = headers
            
            if let paramsBag = paramsBag, paramsBag.count > 0 {
                // will be JSON encoded
                let data = try! JSONSerialization.data(withJSONObject: paramsBag, options: JSONSerialization.WritingOptions.prettyPrinted)
                let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
            }
            
            // Network Only
            if cachePolicy == CachePolicy.networkOnly {
                NetworkManager.getDataFromNetwork(urlRequest: request, completion: completion)
            }
        } else {
            completion([["message": NetworkResponse.noInternet.rawValue]])
        }
    }
    
    
}

extension NetworkManager {
    
    class func getStatesAndCities(completion: @escaping(_ response: [[String: Any]]?) -> ()) {
        NetworkManager.fetchGenericData(urlString: BASE_URL + "docs/data/us-state-capitals.json") { (response) in
            completion(response)
        }
    }
}

extension NetworkManager {
    //Network only
    fileprivate class func getDataFromNetwork(urlRequest : URLRequest, completion: @escaping ([[String: Any]]?) -> ()) {
        getSession().dataTask(with: urlRequest) { (data, response, responseError) in
            NetworkManager.processResponse(data: data, response: response, responseError: responseError, completion: completion)
            }.resume()
    }
}
