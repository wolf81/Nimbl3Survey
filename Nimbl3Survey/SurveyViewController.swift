//
//  SurveyViewController.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 26/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {
    private(set) var survey: Survey
    
    init(survey: Survey) {
        self.survey = survey
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Survey"
        
        self.view.backgroundColor = self.survey.theme.activeColor

        let downImage = UIImage(named: "chevron-down")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: downImage, style: .plain, target: self, action: #selector(dismissAnimated))
    }
    
    // MARK: - Private
 
    dynamic private func dismissAnimated() {
        self.dismiss(animated: true, completion: nil)
    }
}
