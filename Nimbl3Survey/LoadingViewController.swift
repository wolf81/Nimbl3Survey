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

enum LoadingViewControllerState {
    case loading
    case error(error: Error?)
}

class LoadingViewController: UIViewController {
    weak var delegate: LoadingViewControllerDelegate?
    
    var state: LoadingViewControllerState = .loading {
        didSet {
            switch self.state {
            case .error(let error):
                self.loadingView.updateWithError(error)
            case .loading:
                self.loadingView.startLoading()
            }
        }
    }
    
    private var loadingView: LoadingView {
        return self.view as! LoadingView
    }
    
    // MARK: - Initialization & clean-up
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View lifecycle
    
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
        
        switch self.state {
        case .loading:
            self.loadingView.startLoading()
        case .error(let error):
            self.loadingView.updateWithError(error)
        }
    }
}

// MARK: - LoadingViewDelegate

extension LoadingViewController: LoadingViewDelegate {
    func loadingViewReloadAction(_ loadingView: LoadingView) {
        self.delegate?.loadingViewControllerReloadAction(self)
    }
}
