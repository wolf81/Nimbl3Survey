//
//  InterfaceBuilderInstantiable.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 22/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

public protocol InterfaceBuilderInstantiable {
    static var associatedNib : UINib { get }
}

extension InterfaceBuilderInstantiable
{
    static func instantiateFromInterfaceBuilder() -> Self {
        return associatedNib.instantiate(withOwner:nil, options: [:]).first as! Self
    }
    
    static var associatedNib : UINib {
        let name = String(describing: self)
        return UINib(nibName: name, bundle: Bundle.main)
    }
}
