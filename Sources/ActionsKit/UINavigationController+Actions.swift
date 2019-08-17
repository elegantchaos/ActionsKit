
#if os(iOS)

import Actions
import UIKit

public class ValidatableBarButton: ActionResponder, ActionIdentification {
    public let button: UIBarButtonItem
    public let view: UIView

    public func next() -> ActionResponder? {
        return view
    }

    public var actionID: String {
        get { return button.actionID }
        set { button.actionID = newValue }
    }

    init(button: UIBarButtonItem, view: UIView) {
        self.button = button
        self.view = view
    }
}

extension UINavigationController {
    
    public func appendValidatableItems(to items: inout [ActionIdentification], for view: UIView) {
        if let leftButtons = navigationBar.topItem?.leftBarButtonItems {
            items.append(contentsOf: leftButtons.map( { ValidatableBarButton(button: $0, view: view) }))
        }
        if let rightButtons = navigationBar.topItem?.rightBarButtonItems {
            items.append(contentsOf: rightButtons.map( { ValidatableBarButton(button: $0, view: view) }))
        }
    }
}

extension UIBarItem: ActionIdentification {
    @objc public var actionID: String {
        get { return retrieveID() }
        set(value) { storeID(value) }
    }
}


#endif
