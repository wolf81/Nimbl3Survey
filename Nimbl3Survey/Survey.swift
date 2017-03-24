//
//  Survey.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 24/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import Foundation

enum SurveyError: LocalizedError {
    case invalidJson
}

class Survey {
    let title: String
    let description: String
    let imageUrl: URL
    
    init(jsonObject: [String: AnyObject]) throws {
        guard
            let title = jsonObject["title"] as? String,
            let description = jsonObject["description"] as? String,
            let coverImageUrlString = jsonObject["cover_image_url"] as? String else {
                throw SurveyError.invalidJson
        }
        
        self.title = title
        self.description = description
        self.imageUrl = URL(string: coverImageUrlString)!
    }
}
