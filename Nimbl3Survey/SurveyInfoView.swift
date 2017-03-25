//
//  SurveyInfoView.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 22/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit
import AlamofireImage

protocol SurveyInfoViewDelegate: class {
    func surveyInfoViewSurveyAction(_ surveyInfoView: SurveyInfoView)
}

class SurveyInfoView: UIView, InterfaceBuilderInstantiable {
    weak var delegate: SurveyInfoViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var surveyButton: UIButton?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var overlayView: UIView?

    private(set) var survey: Survey? {
        didSet {
            self.titleLabel?.text = self.survey?.title
            self.descriptionLabel?.text = self.survey?.description
            
            if let imageUrl = self.survey?.imageUrl {
                self.imageView?.af_setImage(withURL: imageUrl)
            } else {
                self.imageView?.image = nil
            }
        }
    }
    
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
        self.delegate?.surveyInfoViewSurveyAction(self)
    }

    func updateWithSurvey(_ survey: Survey) {
        self.survey = survey
        
        applyTheme(survey.theme)
    }
    
    // MARK: - Private
    
    private func applyTheme(_ theme: Theme) {
        let bgImage = UIImage.from(color: theme.activeColor)
        surveyButton?.setBackgroundImage(bgImage, for: .normal)
        surveyButton?.setTitleColor(theme.questionColor, for: .normal)
        
        self.descriptionLabel?.textColor = theme.questionColor
        self.titleLabel?.textColor = theme.questionColor
    }
}
