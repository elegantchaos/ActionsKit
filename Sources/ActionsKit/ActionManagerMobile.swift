// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 06/09/2018.
//  All code (c) 2018 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if os(iOS)

import UIKit
import Logger
import Actions
import Localization

let validationChannel = Logger("Validation")
let viewControllerChannel = Channel("com.elegantchaos.actions.ViewController")

public class ActionManagerMobile: ActionManager {
    public class Responder: UIResponder {
        weak var manager: ActionManager! = nil
        
        /**
         Perform an action sent by a user interface item.
         */
        
        @IBAction func performAction(_ sender: Any) {
            manager.perform(sender)
        }
        
        /**
         Return the selector that items should set as their action in order to trigger actions.
         
         Useful for code in client modules that wants to set up UI items programmatically.
         */
        
        public static var performActionSelector: Selector { get { return #selector(performAction(_:)) } }
        
    }

    /**
     Embedded support for the responder chain.
    */
    
    public let responder = Responder()

    
    /**
     Find the "top" view controller for a given view controller.
     
     We check first to see if we've been given a navigation controller and if
     it has a visible controller. If so, we recursively call ourselves for it, in case
     there are nested navigation controllers (is that relevant?).
     
     If we get a result back from the recursive call, we return that.
     
     Otherwise if we had a visible controller, we return that.
     
     Finally we recurse for any child view controllers.
     
     This should result in us finding the view controller for the "top" view
     in the navigation stack.
     */
    
    func topController(for view: UIViewController) -> UIViewController? {
        viewControllerChannel.log("searching \(view)")
        if let nav = view as? UINavigationController, let visible = nav.visibleViewController {
            viewControllerChannel.log("found visible \(visible)")
            if let sub = topController(for: visible) {
                return sub
            }
            
            viewControllerChannel.log("returning visible \(visible)")
            return visible
        }
        
        for subview in view.children {
            if let top = topController(for: subview) {
                viewControllerChannel.log("returning child \(top)")
                return top
            }
        }
        
        return nil
    }

    /**
     On iOS, if there's a navigation controller presenting something,
     we want to allow the chain from it to contribute to the context.
     
     If there's some text being edited, we also want to allow the chain
     from the editing view to contribute.
     
     This is loosely equivalent to the keyResponder and mainResponder
     on macOS.
     */

    public override func responderChains(for item: Any) -> [ActionResponder] {
        var result = super.responderChains(for: item)
        
        // if there's a first responder set (eg text is being edited)
        // include its responder chain
        if let chain = UIResponder.currentFirstResponder {
            result.append(chain)
        }

        // if there's a navigation controller showing something,
        // include its chain
        if let keyWindow = UIApplication.shared.keyWindow, let root = keyWindow.rootViewController {
            let chain: ActionResponder
            if let top = topController(for: root) {
                chain = top
            } else {
                chain = root
            }
            
            result.append(chain) // TODO: check for duplicates?
        }
        
        return result
    }

    /**
     The application delegate may also be a context provider,
     so we add it to the default list if so.
     */

    public override func providers(for item: Any) -> [ActionContextProvider] {
        var result = super.providers(for: item)
        if let provider = UIApplication.shared.delegate as? ActionContextProvider {
            result.append(provider)
        }
        return result
    }
    
    /**
     Hook the action manager into the responder chain.
     
     Annoyingly, the responder chain on iOS is determined at compile time.
     So in addition to calling this method, you need to override the next() method
     for your application delegate, and have it return the action manager's responder instance.
     */

    public func installResponder() {
        responder.manager = self
    }
    
    
    /// Perform validation on some user interface items.
    /// We resolve the actionID for each item, get the validation information for that item, then
    /// use it to set the name, image, enabled state and so on for each item
    /// Currently supported item types are UIButton and UIBarItem.
    ///
    /// - Parameter items: the items to validate
    public func validate(items: [ActionIdentification]) {
        for item in items {
            let identifier = item.actionID
            if !identifier.isEmpty {
                let validation = validate(identifier: item.actionID, info: ActionInfo(sender: item))
                if let button = item as? UIButton {
                    button.isEnabled = validation.enabled
                    button.isHidden = !validation.visible
                    let name = validation.fullName.localized(with: validation.localizationInfo)
                    button.setTitle(name, for: .normal)
                    if let image = validation.icon {
                        button.setImage(image, for: .normal)
                    }
                } else if let item = item as? UIBarItem {
                    item.isEnabled = validation.enabled
                    let name = validation.shortName.localized(with: validation.localizationInfo)
                    item.title = name
                    if let image = validation.icon {
                        item.image = image
                    }
                }
            }
        }
    }

}

extension Action.Validation {
    public var icon: UIImage? {
        let imageName = iconName.localized(with: localizationInfo)
        if #available(iOS 13.0, *), let image = UIImage(systemName: imageName) {
            return image
        } else if let image = UIImage(named: imageName) {
            return image
        } else {
            return nil
        }
    }
}


public protocol HasValidatableActions {
    func validateButtons(with actionManager: ActionManagerMobile)
    func scheduleForValidation(with actionManager: ActionManagerMobile)
}

extension HasValidatableActions {
    public func scheduleForValidation(with actionManager: ActionManagerMobile) {
        OperationQueue.main.addOperation {
            self.validateButtons(with: actionManager)
        }
    }
}

#endif
