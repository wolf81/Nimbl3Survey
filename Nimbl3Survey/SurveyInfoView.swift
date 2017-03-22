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
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        if let surveyButton = self.surveyButton {
            let bgImage = UIImage.from(color: UIColor.red)
            surveyButton.setBackgroundImage(bgImage, for: .normal)
            let cornerRadius: CGFloat = surveyButton.frame.height / 2
            self.surveyButton?.layer.cornerRadius = cornerRadius
            self.surveyButton?.layer.masksToBounds = true
        }
    }
    
    // MARK: - Public
    
    @IBAction func surveyAction() {
        print("perform survey action")
    }
}
