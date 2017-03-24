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

//Integrate with the following API (Oauth 2 API):
//
//Endpoints: https://nimbl3-survey-api.herokuapp.com
//
//Credentials:
//
//Params name: access_token
//Token: d9584af77d8c0d6622e2b3c554ed520b2ae64ba0721e52daa12d6eaa5e5cdd93

//To get the high resolution image just append “l” to the image url you obtain in the API response
//If you get timeout or it’s too slow you can paginate the results using  page, per_page query params  e.g. https://nimbl3-survey-api.herokuapp.com/surveys.json?page=1&per_page=10
//If the token is expired, a new one can be obtained via https://nimbl3-survey-api.herokuapp.com/oauth/token
//
//curl https://nimbl3-survey-api.herokuapp.com/oauth/token --data  "grant_type=password&username=carlos@nimbl3.com&password=antikera"
//
//The response should be:
//
//{"access_token":"d9584af77d8c0d6622e2b3c554ed520b2ae64ba0721e52daa12d6eaa5e5cdd93","token_type":"bearer","expires_in":7200,"created_at":1485174186}

enum SurveyApiClientError: Error {
    case invalidHttpStatusCode(code: Int)
    case noData
}

class SurveyApiClient {
    static let shared = SurveyApiClient()

    private let baseUrl = URL(string: "https://nimbl3-survey-api.herokuapp.com")!

    private var oauthClient: OAuth2?

    private var token: String?
    
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
    
    func surveys(page: Int = 1, count: Int = 10, completion: @escaping ((_ surveys: [Survey]?, _ error: Error?) -> Void)) throws {
        authorize { (success, error) in
            guard success == true else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            let url = self.baseUrl.appendingPathComponent("surveys.json?page=\(page)&per_page=\(count)")
            let req = (self.oauthClient?.request(forURL: url))!
            let task = self.oauthClient?.session.dataTask(with: req) { data, response, error in
                let httpResponse = (response as! HTTPURLResponse)
                let isValidResponse = (200 ..< 300).contains(httpResponse.statusCode)
                
                guard isValidResponse == true else {
                    DispatchQueue.main.async {
                        completion(nil, SurveyApiClientError.invalidHttpStatusCode(code: httpResponse.statusCode))
                    }
                    return
                }

                guard error == nil else {
                    DispatchQueue.main.async {
                        completion(nil, error!)
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
                    var surveys = [Survey]()
                    
                    guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Array<Any> else {
                        return
                    }
                    
                    for jsonObject in json {
                        let survey = try Survey(jsonObject: jsonObject as! [String: AnyObject])
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
