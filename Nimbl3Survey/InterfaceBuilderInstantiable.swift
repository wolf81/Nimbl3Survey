//
//  InterfaceBuilderInstantiable.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 22/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

// MARK: - Protocol Declaration

public protocol InterfaceBuilderInstantiable
{
    /// The UINib that contains the view
    ///
    /// Defaults to the swift class name if not implemented
    static var associatedNib : UINib { get }
}

// MARK: - Default Implementation

extension InterfaceBuilderInstantiable
{
    /// Creates a new instance from the associated Xib
    ///
    /// - Returns: A new instance of this object loaded from xib
    static func instantiateFromInterfaceBuilder() -> Self
    {
        return associatedNib.instantiate(withOwner:nil, options: [:]).first as! Self
    }
    
    static var associatedNib : UINib
    {
        let name = String(describing: self)
        return UINib(nibName: name, bundle: Bundle.main)
    }
}
