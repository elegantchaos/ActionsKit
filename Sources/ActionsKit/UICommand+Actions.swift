// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/08/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Actions
import UIKit

@available(iOS 13.0, *) extension UICommand: ActionIdentification {
    public var actionID: String {
        get { return (propertyList as? String) ?? "" }
        set { fatalError("can't set actionID for UICommand") }
    }
}
