//
//  Network.swift
//  FlikrTest
//
//  Created by Prabhjot Singh on 29/05/21.
//  Copyright © 2021 Gogana Solutions. All rights reserved.
//



import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON


class APIManager {
    
    static let baseUrl = "https://www.flickr.com/services/rest/"
    
    typealias parameters = [String:Any]
    
    enum ApiResult {
        case success(JSON)
        case failure(RequestError)
    }
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError(JSON)
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError
        case serverUnavailable
    }
    
    // for requesting the data from url with parameters and http method
    
    static func requestData(url:String,method:HTTPMethod,parameters:parameters?,completion: @escaping (ApiResult)->Void) {
        
        let header =  ["Content-Type": "application/x-www-form-urlencoded"]
        
        var urlRequest = URLRequest(url: URL(string: baseUrl+url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = method.rawValue
        if let parameters = parameters {
            let parameterData = parameters.reduce("") { (result, param) -> String in
                return result + "&\(param.key)=\(param.value as! String)"
            }.data(using: .utf8)
            urlRequest.httpBody = parameterData
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                completion(ApiResult.failure(.connectionError))
            }else if let data = data ,let responseCode = response as? HTTPURLResponse {
                do {
                    let responseJson = try JSON(data: data)
//                    print("responseCode : \(responseCode.statusCode)")
//                    print("responseJSON : \(responseJson)")
                    switch responseCode.statusCode {
                    case 200:
                    completion(ApiResult.success(responseJson))
                    case 400...499:
                    completion(ApiResult.failure(.authorizationError(responseJson)))
                    case 500...599:
                    completion(ApiResult.failure(.serverError))
                    default:
                        completion(ApiResult.failure(.unknownError))
                        break
                    }
                }
                catch let parseJSONError {
                    completion(ApiResult.failure(.unknownError))
                    print("error on parsing request to JSON : \(parseJSONError)")
                }
            }
        }.resume()
    }
}