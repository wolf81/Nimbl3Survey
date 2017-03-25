//
//  SurveysViewController.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 25/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

class SurveysViewController: UIPageViewController {
    private var refreshButton: UIBarButtonItem?
    private var menuButton: UIBarButtonItem?
    
    fileprivate var pageIndicatorView: PageIndicatorView?

    private(set) var surveyViewControllers = [UIViewController]()

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
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Surveys"
        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = []
        
        let refreshImage = UIImage(named: "refresh")?.withRenderingMode(.alwaysTemplate)
        self.refreshButton = UIBarButtonItem(image: refreshImage, style: .plain, target: self, action: #selector(refreshAction))
        self.navigationItem.leftBarButtonItem = self.refreshButton
        self.refreshButton?.tintColor = .black
        
        let menuImage = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
        self.menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(menuAction))
        self.navigationItem.rightBarButtonItem = self.menuButton
        self.menuButton?.tintColor = .black

        let pageIndicatorView = PageIndicatorView()
        self.view.addSubview(pageIndicatorView);
        self.pageIndicatorView = pageIndicatorView
        
        self.dataSource = self
        self.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        let bounds = self.view.bounds
        
        if let indicatorView = self.pageIndicatorView {
            let margin: CGFloat = 10
            let viewSize = indicatorView.sizeThatFits(bounds.size)
            let x = bounds.width - viewSize.width - margin
            indicatorView.frame = CGRect(x: x, y: 0, width: viewSize.width, height: viewSize.height)
        }
        
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Public
    
    func updateWithSurveys(_ surveys: [Survey]) {
        var viewControllers = [UIViewController]()
        for survey in surveys {
            let viewController = SurveyViewController(survey: survey)
            viewControllers.append(viewController)
        }
        self.surveyViewControllers = viewControllers

        self.pageIndicatorView?.count = viewControllers.count
        
        self.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
    }
}

extension SurveysViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let idx = self.surveyViewControllers.index(of: viewController), idx > 0 {
            return self.surveyViewControllers[idx - 1]
        }
        
        return nil
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let idx = self.surveyViewControllers.index(of: viewController), (idx < surveyViewControllers.count - 1) {
            return self.surveyViewControllers[idx + 1]
        }

        return nil
    }
}

extension SurveysViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewController = pageViewController.viewControllers?.first {
            if let idx = self.surveyViewControllers.index(of: viewController) {
                self.pageIndicatorView?.index = idx
            }
        }
    }
}
