//
//  LoadingView.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 26/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

protocol LoadingViewDelegate: class {
    func loadingViewReloadAction(_ loadingView: LoadingView)
}

class LoadingView: UIView, InterfaceBuilderInstantiable {
    weak var delegate: LoadingViewDelegate?
    
    var animationDuration: TimeInterval = 0.2
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var infoLabel: UILabel?
    @IBOutlet weak var reloadButton: UIButton?

    // MARK: - Initialization & clean-up
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel?.alpha = 0.0
        self.reloadButton?.alpha = 0.0
        self.infoLabel?.alpha = 0.0
        self.imageView?.alpha = 0.0
        
        self.imageView?.tintColor = .white
    }
    
    // MARK: - Actions
    
    @IBAction func reloadAction() {
        self.delegate?.loadingViewReloadAction(self)
    }
    
    // MARK: - Public
    
    func updateWithError(_ error: Error?) {
        self.titleLabel?.text = "Error"
        self.infoLabel?.text = error?.localizedDescription ?? "An unknown error occured."
        self.imageView?.stopRotation()

        UIView.animate(withDuration: self.animationDuration, delay: 0, options: .beginFromCurrentState, animations: {
            self.titleLabel?.alpha = 1.0
            self.reloadButton?.alpha = 1.0
            self.imageView?.alpha = 0.0
            self.infoLabel?.alpha = 1.0
        }, completion: nil)
    }
    
    func startLoading() {
        self.titleLabel?.text = "Loading ..."
        self.infoLabel?.text = nil
        self.imageView?.startRotation(2.0, repeatCount: Float.infinity, clockwise: true)

        UIView.animate(withDuration: self.animationDuration, delay: 0, options: .beginFromCurrentState, animations: {
            self.titleLabel?.alpha = 1.0
            self.reloadButton?.alpha = 0.0
            self.imageView?.alpha = 1.0
            self.infoLabel?.alpha = 0.0
        }, completion: nil)
    }
    
    func stopLoading() {
        self.imageView?.stopRotation()
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, options: .beginFromCurrentState, animations: {
            self.titleLabel?.alpha = 1.0
            self.reloadButton?.alpha = 1.0
            self.imageView?.alpha = 0.0
            self.infoLabel?.alpha = 1.0
        }, completion: nil)
    }
    
    // MARK: - Private
}
