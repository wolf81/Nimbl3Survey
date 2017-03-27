//
//  SurveysViewController.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 25/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

class SurveysViewController: UIPageViewController {
    private var reloadButton: UIBarButtonItem?
    private var menuButton: UIBarButtonItem?
    
    fileprivate var pageIndicatorView = PageIndicatorView()

    fileprivate var loadingViewController: LoadingViewController? {
        return self.viewControllers?.first as? LoadingViewController
    }

    fileprivate var currentPageIndex: Int = 0 {
        didSet {
            self.pageIndicatorView.index = self.currentPageIndex
        }
    }

    private(set) var pageViewControllers = [UIViewController]() {
        didSet {
            self.pageIndicatorView.count = self.pageViewControllers.count

            if let viewController = self.pageViewControllers.first {
                self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
            } else {
                let viewController = LoadingViewController()
                viewController.delegate = self
                self.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
            }
            
            UIView.animate(withDuration: AnimationDuration.short) { 
                self.pageIndicatorView.alpha = 1.0
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

        let reloadImage = UIImage(named: "refresh")
        self.reloadButton = UIBarButtonItem(image: reloadImage, style: .plain, target: self, action: #selector(reloadAction))
        
        let menuImage = UIImage(named: "menu")
        self.menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(menuAction))

        updateNavigationItemsVisible(false)
        
        self.view.addSubview(self.pageIndicatorView);
        self.pageIndicatorView.alpha = 0.0
        self.pageIndicatorView.animationDuration = AnimationDuration.short
        self.pageIndicatorView.delegate = self

        self.dataSource = self
        self.delegate = self
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.pageViewControllers.count == 0 {
            reloadAction()
        }
    }
    
    override func viewDidLayoutSubviews() {
        let bounds = self.view.bounds
        
        let margin: CGFloat = 10
        let maxHeight = bounds.height - margin * 2 - self.topLayoutGuide.length
        let sizeConstraint = CGSize(width: bounds.width, height: maxHeight)
        let viewSize = self.pageIndicatorView.sizeThatFits(sizeConstraint)
        let x = bounds.width - viewSize.width - margin
        let y = self.topLayoutGuide.length + margin
        self.pageIndicatorView.frame = CGRect(x: x, y: y, width: viewSize.width, height: viewSize.height)
        
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Actions
    
    @IBAction func reloadAction() {
        if self.loadingViewController == nil {
            self.pageViewControllers = []
        }
        
        self.loadingViewController?.state = .loading
        updateNavigationItemsVisible(false)
        
        do {
            try SurveyApiClient.shared.loadSurveys(page: 1, count: 5, completion: { (result, error) in
                guard let surveys = result else {
                    self.loadingViewController?.state = .error(error: error)
                    self.updateNavigationItemsVisible(false)
                    return
                }

                self.updateNavigationItemsVisible(true)
                self.updateWithSurveys(surveys)
            })
        } catch let error {
            self.loadingViewController?.state = .error(error: error)
            updateNavigationItemsVisible(false)
        }
    }
    
    @IBAction func menuAction() {
        print("perform menu action")
    }
    
    // MARK: - Private
    
    private func updateNavigationItemsVisible(_ isVisible: Bool) {
        if isVisible  {
            self.navigationItem.setLeftBarButton(self.reloadButton, animated: true)
            self.navigationItem.setRightBarButton(self.menuButton, animated: true)
        } else {
            self.navigationItem.setLeftBarButton(nil, animated: true)
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    fileprivate func navigateToPageIndex(_ pageIndex: Int) {
        guard (0 ..< self.pageViewControllers.count).contains(pageIndex) else {
            return
        }
        
        let direction: UIPageViewControllerNavigationDirection = pageIndex > self.currentPageIndex ? .forward : .reverse
        
        let nextViewController = self.pageViewControllers[pageIndex]
        setViewControllers([nextViewController], direction: direction, animated: true) { finished in
            self.currentPageIndex = pageIndex
        }
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

// MARK: - 

extension SurveysViewController: LoadingViewControllerDelegate {
    func loadingViewControllerReloadAction(_ viewController: LoadingViewController) {
        reloadAction()
    }
}

// MARK: - PageIndicatorViewDelegate

extension SurveysViewController: PageIndicatorViewDelegate {
    func pageIndicatorViewNavigateNextAction(_ view: PageIndicatorView) {
        navigateToPageIndex(self.currentPageIndex - 1)
    }
    
    func pageIndicatorViewNavigatePreviousAction(_ view: PageIndicatorView) {
        navigateToPageIndex(self.currentPageIndex + 1)
    }

    func pageIndicatorView(_ view: PageIndicatorView, touchedIndicatorAtIndex index: Int) {
        navigateToPageIndex(index)
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
