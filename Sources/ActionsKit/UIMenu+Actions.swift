// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 18/03/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if canImport(UIKit)
import Actions
import UIKit

@available(iOS 13.0, *) extension UIMenu: ActionIdentification {
    public var actionID: String {
        get { return identifier.rawValue }
        set { fatalError("can't set actionID for UIMenu") }
    }
}

extension UIMenuItem: ActionIdentification {
    public var actionID: String {
        get { return retrieveID() }
        set { storeID(newValue) }
    }
}
#endif
