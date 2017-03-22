//
//  SurveyInfoView.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 22/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

class SurveyInfoView: UIView, InterfaceBuilderInstantiable {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var detailsLabel: UILabel?
    @IBOutlet weak var surveyButton: UIButton?
    @IBOutlet weak var imageView: UIImageView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let buttonImage = UIImage.from(color: UIColor.red)
        self.surveyButton?.setBackgroundImage(buttonImage, for: .normal)
    }
    
    @IBAction func surveyAction() {
        print("perform survey action")
    }
}
