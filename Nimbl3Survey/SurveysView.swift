//
//  SurveysView.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 24/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

class SurveysView: UIView, InterfaceBuilderInstantiable {
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var pageIndicatorView: PageIndicatorView?
    
    // MARK: - Public
    
    func updateWithSurveys(_ surveys: [Survey]) {
        let height = CGFloat(max(1, surveys.count)) * self.bounds.height
        let width = self.bounds.width
        
        self.scrollView?.contentSize = CGSize(width: width, height: height)        
        self.pageIndicatorView?.count = surveys.count
    }
}
