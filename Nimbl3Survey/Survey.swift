//
//  Survey.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 24/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import Foundation

enum SurveyError: LocalizedError {
    case invalidJson(json: [String: AnyObject])
    
    var errorDescription: String? {
        switch self {
        case .invalidJson(let json):
            return NSLocalizedString("invalid json, cannot create \"Survey\" object from json: \(json)", comment: "")
        }
    }
}

class Survey {
    let title: String
    let description: String
    let imageUrl: URL
    
    init(json: [String: AnyObject]) throws {
        guard
            let title = json["title"] as? String,
            let description = json["description"] as? String,
            let coverImageUrlString = json["cover_image_url"] as? String else {
                throw SurveyError.invalidJson(json: json)
        }
        
        self.title = title
        self.description = description
        self.imageUrl = URL(string: coverImageUrlString)!
    }
}
