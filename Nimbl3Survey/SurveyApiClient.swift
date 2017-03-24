//
//  SurveyApiClient.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 23/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import Foundation
import p2_OAuth2
import Alamofire

// The SurveyApiClient retrieves data from the back-end using OAuth2.
// The access token is automatically refreshed and added to the keychain by the 
// included OAuth2 library. This library can then be used to construct new
// requests that automatically include the correct headers.
// 
// For convienience it's recommended by the author of this library to 
// authorize at the start of every request. The OAuth2 client should not 
// actually perform a new authorization request if our access token in the 
// keychain is still valid.

// TODO 1: Add support for image loading. Automatically load high resolution
// images for supported devices. High resolution images can be loaded by 
// appending "l" to the image URL.

// TODO 2: Load theme as well and apply to the survey info screen.

enum SurveyApiClientError: LocalizedError {
    case invalidHttpStatusCode(code: Int)
    case failedConversionToJson
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidHttpStatusCode(let code): return NSLocalizedString("invalid http status code: \(code)", comment: "")
        case .noData: return NSLocalizedString("no data from back-end", comment: "")
        case .failedConversionToJson: return NSLocalizedString("failed to convert data to json", comment: "")
        }
    }
}

class SurveyApiClient {
    static let shared = SurveyApiClient()

    private let baseUrl = URL(string: "https://nimbl3-survey-api.herokuapp.com")!

    private var oauthClient: OAuth2?
    
    private func authorize(completion: @escaping ((_ success: Bool, _ error: Error?) -> Void)) {
        let oauthClient = OAuth2PasswordGrant(settings: [
            "authorize_uri": baseUrl.appendingPathComponent("oauth/token").absoluteString
            ] as OAuth2JSON)
        self.oauthClient = oauthClient
        
        oauthClient.username = "carlos@nimbl3.com"
        oauthClient.password = "antikera"
        oauthClient.logger = OAuth2DebugLogger(.debug)
        
        oauthClient.authorize { (json, error) in
            if error != nil {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func loadSurveys(page: Int = 1, count: Int = 10, completion: @escaping ((_ result: [Survey]?, _ error: Error?) -> Void)) throws {
        authorize { (success, error) in
            guard success == true else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            let url = self.baseUrl.appendingPathComponent("surveys.json?page=\(page)&per_page=\(count)")
            let req = (self.oauthClient?.request(forURL: url))!
            let task = self.oauthClient?.session.dataTask(with: req) { data, response, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        completion(nil, error!)
                    }
                    return
                }

                // Make sure the HTTP status code is in the succes range.
                let httpResponse = (response as! HTTPURLResponse)
                let isValidResponse = (200 ..< 300).contains(httpResponse.statusCode)
                guard isValidResponse == true else {
                    DispatchQueue.main.async {
                        completion(nil, SurveyApiClientError.invalidHttpStatusCode(code: httpResponse.statusCode))
                    }
                    return
                }
                
                guard let jsonData = data else {
                    DispatchQueue.main.async {
                        completion(nil, SurveyApiClientError.noData)
                    }
                    return
                }
                
                do {
                    guard let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Array<Any> else {
                        DispatchQueue.main.async {
                            completion(nil, SurveyApiClientError.failedConversionToJson)
                        }
                        return
                    }
                    
                    var surveys = [Survey]()
                    
                    for jsonObject in jsonArray {
                        let survey = try Survey(json: jsonObject as! [String: AnyObject])
                        surveys.append(survey)
                    }
                    
                    DispatchQueue.main.async {
                        completion(surveys, nil)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
            task?.resume()
        }
    }
}
