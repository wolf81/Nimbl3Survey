//
//  SurveyViewController.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 24/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {
    let survey: Survey
    
    override func loadView() {
        self.view = SurveyInfoView.instantiateFromInterfaceBuilder()
    }
    
    var surveyInfoView: SurveyInfoView {
        return self.view as! SurveyInfoView
    }
    
    init(survey: Survey) {
        self.survey = survey
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.surveyInfoView.updateWithSurvey(survey)
    }
}
