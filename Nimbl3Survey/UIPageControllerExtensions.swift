//
//  UIPageControllerExtensions.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 26/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

extension UIPageViewController {
//    func setViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewControllerNavigationDirection, invalidateCache: Bool, animated: Bool, completion: ((Bool) -> Swift.Void)? = nil) {
//    
//        let viewControllers = self.viewControllers
//        
//        if invalidateCache && self.transitionStyle == .scroll {
//            var nextViewController: UIViewController
//            
//            let currentViewController = viewControllers?.first!
//            
//            switch direction {
//            case .forward:
//                nextViewController = self.dataSource?.pageViewController(self, viewControllerAfter: currentViewController)
//            case .reverse:
//                nextViewController = self.dataSource?.pageViewController(self, viewControllerBefore: currentViewController)
//            }
//            
//        } else {
//        
//        }
//    }
}

/*
- (void)setViewControllers:(NSArray *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction invalidateCache:(BOOL)invalidateCache animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    NSArray *vcs = viewControllers;
    __weak UIPageViewController *mySelf = self;
    
    if (invalidateCache && self.transitionStyle == UIPageViewControllerTransitionStyleScroll) {
        UIViewController *neighborViewController = (direction == UIPageViewControllerNavigationDirectionForward
            ? [self.dataSource pageViewController:self viewControllerBeforeViewController:viewControllers[0]]
            : [self.dataSource pageViewController:self viewControllerAfterViewController:viewControllers[0]]);
        [self setViewControllers:@[neighborViewController] direction:direction animated:NO completion:^(BOOL finished) {
            [mySelf setViewControllers:vcs direction:direction animated:animated completion:completion];
        }];
    }
    else {
        [mySelf setViewControllers:vcs direction:direction animated:animated completion:completion];
    }
}
*/
