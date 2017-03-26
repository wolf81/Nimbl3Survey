//
//  SurveyInfoViewController.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 24/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

class SurveyInfoViewController: UIViewController {
    let survey: Survey
    
    var surveyInfoView: SurveyInfoView {
        return self.view as! SurveyInfoView
    }
    
    // MARK: - Initialization & clean-up
    
    init(survey: Survey) {
        self.survey = survey
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - View lifecycle
    
    override func loadView() {
        self.view = SurveyInfoView.instantiateFromInterfaceBuilder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.surveyInfoView.updateWithSurvey(self.survey)
        self.surveyInfoView.delegate = self
    }
}

// MARK: - SurveyInfoViewDelegate

extension SurveyInfoViewController: SurveyInfoViewDelegate {
    func surveyInfoViewSurveyAction(_ surveyInfoView: SurveyInfoView) {
        guard let survey = surveyInfoView.survey else { return }
        
        let viewController = SurveyViewController(survey: survey)
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true, completion: nil)
    }
}
