//
//  Theme.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 25/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

/*
"color_active": "#9B2828",
"color_inactive": "#000000",
"color_question": "#ffffff",
"color_answer_normal": "#FFFFFF",
"color_answer_inactive": "#FFFFFF"
 */

class Theme {
    private(set) var activeColor: UIColor = UIColor.white
    private(set) var inactiveColor: UIColor = UIColor.white
    private(set) var questionColor: UIColor = UIColor.white
    private(set) var normalAnswerColor: UIColor = UIColor.white
    private(set) var inactiveAnswerColor: UIColor = UIColor.white
    
    init(json: [String: AnyObject]) {    
        if let colorString = json["color_active"] as? String {
            self.activeColor = UIColor(hexString: colorString)
        }
        
        if let colorString = json["color_inactive"] as? String {
            self.inactiveColor = UIColor(hexString: colorString)
        }

        if let colorString = json["color_question"] as? String {
            self.questionColor = UIColor(hexString: colorString)
        }

        if let colorString = json["color_answer_normal"] as? String {
            self.normalAnswerColor = UIColor(hexString: colorString)
        }

        if let colorString = json["color_answer_inactive"] as? String {
            self.inactiveAnswerColor = UIColor(hexString: colorString)
        }
    }
}
