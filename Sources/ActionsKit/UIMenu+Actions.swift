//
//  File.swift
//  
//
//  Created by Developer on 17/08/2019.
//

import Actions
import UIKit

extension UIMenu: ActionIdentification {
    public var actionID: String {
        get { return identifier.rawValue }
        set { fatalError("can't set actionID for UIMenu") }
    }
}
