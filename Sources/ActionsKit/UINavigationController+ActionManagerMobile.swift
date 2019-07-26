
#if os(iOS)

import Actions
import UIKit


extension UINavigationController {
    class ValidatableBarButton: ActionResponder, ActionIdentification {
        var actionID: String {
            get { return button.actionID }
            set { button.actionID = newValue }
        }
        let button: UIBarButtonItem
        let view: UIView
        init(button: UIBarButtonItem, view: UIView) {
            self.button = button
            self.view = view
        }
        func next() -> ActionResponder? {
            return view
        }
    }
    
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
