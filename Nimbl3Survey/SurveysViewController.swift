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
    
    fileprivate var isNavigating: Bool = false

    fileprivate var pageIndicatorView: PageIndicatorView?

    fileprivate var currentPageIndex: Int = 0 {
        didSet {
            self.pageIndicatorView?.index = self.currentPageIndex
        }
    }

    private(set) var pageViewControllers = [UIViewController]() {
        didSet {
            self.pageIndicatorView?.count = self.pageViewControllers.count

            if let viewController = self.pageViewControllers.first {
                self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
            } else {
                self.setViewControllers([UIViewController()], direction: .reverse, animated: true, completion: nil)
            }
            
            self.currentPageIndex = 0
        }
    }

    // MARK: - Initialization & clean-up
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.pageViewControllers = []
    }
    
    // MARK: - View lifecycle
  
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
        self.pageIndicatorView?.delegate = self
        
        self.dataSource = self
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.pageViewControllers.count == 0 {
            refreshAction()
        }
    }
    
    override func viewDidLayoutSubviews() {
        let bounds = self.view.bounds
        
        if let indicatorView = self.pageIndicatorView {
            let margin: CGFloat = 10
            let maxHeight = bounds.height - margin * 2 - self.topLayoutGuide.length
            let sizeConstraint = CGSize(width: bounds.width, height: maxHeight)
            let viewSize = indicatorView.sizeThatFits(sizeConstraint)
            let x = bounds.width - viewSize.width - margin
            let y = self.topLayoutGuide.length + margin
            indicatorView.frame = CGRect(x: x, y: y, width: viewSize.width, height: viewSize.height)
        }
        
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Actions
    
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
    
    // MARK: - Private
    
    func navigateToPageAtIndex(_ pageIndex: Int) {
        self.isNavigating = true

        guard pageIndex != self.currentPageIndex else {
            self.isNavigating = false
            return
        }
        
        var navDirection: UIPageViewControllerNavigationDirection
        var nextPageIndex: Int
        
        switch self.currentPageIndex {
        case _ where self.currentPageIndex > pageIndex:
            navDirection = .reverse
            nextPageIndex = self.currentPageIndex - 1
        case _ where self.currentPageIndex < pageIndex:
            navDirection = .forward
            nextPageIndex = self.currentPageIndex + 1
        default: return
        }

        let nextViewController = self.pageViewControllers[nextPageIndex]

        setViewControllers([nextViewController], direction: navDirection, animated: true, completion: { [weak self] finished in
            DispatchQueue.main.async {
                guard let pvc = self else { return }
                
                // Prevent a caching bug by navigating again to the same view controller without animation.
                pvc.setViewControllers([nextViewController], direction: navDirection, animated: false, completion: nil)
                
                if let currentPageIndex = pvc.pageViewControllers.index(of: nextViewController) {
                    pvc.currentPageIndex = currentPageIndex
                }
                
                pvc.navigateToPageAtIndex(pageIndex)
            }
        })
    }
    
    // MARK: - Public
    
    func updateWithSurveys(_ surveys: [Survey]) {
        var viewControllers = [UIViewController]()
        for survey in surveys {
            let viewController = SurveyInfoViewController(survey: survey)
            viewControllers.append(viewController)
        }
        self.pageViewControllers = viewControllers
    }
}

// MARK: - UIPageViewControllerDataSource

extension SurveysViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let idx = self.pageViewControllers.index(of: viewController), idx > 0 {
            return self.pageViewControllers[idx - 1]
        }
        
        return nil
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let idx = self.pageViewControllers.index(of: viewController), (idx < pageViewControllers.count - 1) {
            return self.pageViewControllers[idx + 1]
        }

        return nil
    }
}

// MARK: - PageIndicatorViewDelegate

extension SurveysViewController: PageIndicatorViewDelegate {
    func pageIndicatorView(_ view: PageIndicatorView, touchedIndicatorAtIndex index: Int) {
        guard self.isNavigating == false else { return }

        navigateToPageAtIndex(index)
    }
}

// MARK: - UIPageViewControllerDelegate

extension SurveysViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed == true else { return }
        
        guard let viewController = pageViewController.viewControllers?.first else {
            return
        }
        
        self.currentPageIndex = self.pageViewControllers.index(of: viewController) ?? 0
    }
}
