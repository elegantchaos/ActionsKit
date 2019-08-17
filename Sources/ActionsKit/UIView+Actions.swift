// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 26/07/2019.
//  All code (c) 2018 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if os(iOS)

import Actions
import UIKit

extension UIView: ActionIdentification {
    @objc public var actionID: String {
        get { return retrieveID() }
        set { storeID(newValue) }
    }
}

extension UIView: HasValidatableActions {
    public func appendValidatableItems(to items: inout [ActionIdentification]) {
        if !isHidden {
            if let viewItem = self as? UIControl, !viewItem.actionID.isEmpty {
                validationChannel.log("\(viewItem.actionID)")
                items.append(viewItem)
            }
            for subview in subviews {
                subview.appendValidatableItems(to: &items)
            }
        }
    }
    
    public func validateButtons(with actionManager: ActionManagerMobile) {
        var items = [ActionIdentification]()
        appendValidatableItems(to: &items)
        actionManager.validate(items: items)
    }

}

#endif
