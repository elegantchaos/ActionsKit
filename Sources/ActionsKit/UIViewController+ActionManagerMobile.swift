
#if os(iOS)

import Actions
import UIKit


extension UIViewController: HasValidatableActions {
    public func validateButtons(with actionManager: ActionManagerMobile) {
        var items = [ActionIdentification]()
        view.appendValidatableItems(to: &items)
        navigationController?.appendValidatableItems(to: &items, for: view)
        actionManager.validate(items: items)
    }
}


#endif
