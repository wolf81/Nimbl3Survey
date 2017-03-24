//
//  SurveysViewController.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 22/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

class SurveysViewController: UIViewController {
    @IBOutlet weak var refreshButton: UIBarButtonItem?
    @IBOutlet weak var menuButton: UIBarButtonItem?
    
    private var surveyInfoView: SurveyInfoView {
        return self.view as! SurveyInfoView
    }
    
    override func loadView() {
        self.view = SurveyInfoView.instantiateFromInterfaceBuilder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.surveyInfoView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func refreshAction() {
        print("perform refresh action")
        
        self.refreshButton?.isEnabled = false
        
        do {
            try SurveyApiClient.shared.loadSurveys(page: 1, count: 3, completion: { (result, error) in
                self.refreshButton?.isEnabled = true

                guard let surveys = result else {
                    // TODO: Show error.
                    return
                }
                
                self.updateWithSurveys(surveys)
            })
        } catch let error {
            print("error: \(error)")
        }
    }
    
    @IBAction func menuAction() {
        print("perform menu action")
    }
    
    
    // MARK: - Public
    
    func updateWithSurveys(_ surveys: [Survey]) {
        guard let survey = surveys.first else {
            return
        }
        
        self.surveyInfoView.updateWithSurvey(survey)
    }
}

extension SurveysViewController: SurveyInfoViewDelegate {
    func surveyInfoViewSurveyAction(_ surveyInfoView: SurveyInfoView) {
        let viewController = SurveyViewController()
        present(viewController, animated: true, completion: nil)
    }
}

