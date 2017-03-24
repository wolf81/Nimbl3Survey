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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
