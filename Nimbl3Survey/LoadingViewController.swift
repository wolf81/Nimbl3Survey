//
//  LoadingViewController.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 26/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

protocol LoadingViewControllerDelegate: class {
    func loadingViewControllerReloadAction(_ viewController: LoadingViewController)
}

class LoadingViewController: UIViewController {
    weak var delegate: LoadingViewControllerDelegate?
    
    private var loadingView: LoadingView {
        return self.view as! LoadingView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        self.view = LoadingView.instantiateFromInterfaceBuilder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = AppTheme.backgroundColor
        
        self.loadingView.animationDuration = AnimationDuration.short
        self.loadingView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadingView.startLoading()
    }
    
    // MARK: Public
    
    func startLoading() {
        self.loadingView.startLoading()
    }
    
    func updateWithError(_ error: Error?) {
        self.loadingView.updateWithError(error)
    }
    
    func stopLoading() {
        self.loadingView.stopLoading()
    }
}

// MARK: - LoadingViewDelegate

extension LoadingViewController: LoadingViewDelegate {
    func loadingViewReloadAction(_ loadingView: LoadingView) {
        self.delegate?.loadingViewControllerReloadAction(self)
    }
}
