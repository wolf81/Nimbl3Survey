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

    private(set) var surveyViewControllers = [UIViewController]() {
        didSet {
            self.pageIndicatorView?.count = self.surveyViewControllers.count

            if let viewController = self.surveyViewControllers.first {
                self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
            } else {
                self.setViewControllers([UIViewController()], direction: .reverse, animated: true, completion: nil)
            }
        }
    }

    @IBAction func refreshAction() {
        self.refreshButton?.isEnabled = false
        
        do {
            try SurveyApiClient.shared.loadSurveys(page: 1, count: 5, completion: { (result, error) in
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
        
        self.view.backgroundColor = AppTheme.backgroundColor
        
        let refreshImage = UIImage(named: "refresh")?.withRenderingMode(.alwaysTemplate)
        self.refreshButton = UIBarButtonItem(image: refreshImage, style: .plain, target: self, action: #selector(refreshAction))
        self.navigationItem.leftBarButtonItem = self.refreshButton
        
        let menuImage = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
        self.menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(menuAction))
        self.navigationItem.rightBarButtonItem = self.menuButton

        let pageIndicatorView = PageIndicatorView()
        self.view.addSubview(pageIndicatorView);
        self.pageIndicatorView = pageIndicatorView
        
        self.dataSource = self
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.surveyViewControllers.count == 0 {
            refreshAction()
        }
    }
    
    override func viewDidLayoutSubviews() {
        let bounds = self.view.bounds
        
        if let indicatorView = self.pageIndicatorView {
            let margin: CGFloat = 10
            let maxHeight = bounds.height - margin * 2
            let sizeConstraint = CGSize(width: bounds.width, height: maxHeight)
            let viewSize = indicatorView.sizeThatFits(sizeConstraint)
            let x = bounds.width - viewSize.width - margin
            indicatorView.frame = CGRect(x: x, y: margin, width: viewSize.width, height: viewSize.height)
        }
        
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.surveyViewControllers = []
    }
    
    // MARK: - Public
    
    func updateWithSurveys(_ surveys: [Survey]) {
        var viewControllers = [UIViewController]()
        for survey in surveys {
            let viewController = SurveyViewController(survey: survey)
            viewControllers.append(viewController)
        }
        self.surveyViewControllers = viewControllers
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
