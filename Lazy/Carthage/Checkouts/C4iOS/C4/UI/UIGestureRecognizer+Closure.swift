// Copyright © 2014 C4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.


import Foundation
import UIKit

private var handlerAssociationKey: UInt8 = 0
private var viewAssociationKey: UInt8 = 0

extension UIGestureRecognizer {
    
    /// The current location of the gesture in the reference view.
    public var location: C4Point {
        get {
            return C4Point(locationInView(referenceView))
        }
    }
    
    internal var referenceView: UIView? {
        get {
            let weakViewWrapper: WeakViewWrapper? = objc_getAssociatedObject(self, &viewAssociationKey) as? WeakViewWrapper
            return weakViewWrapper?.view
        }
        set {
            var weakViewWrapper: WeakViewWrapper? = objc_getAssociatedObject(self, &viewAssociationKey) as? WeakViewWrapper
            if weakViewWrapper == nil {
                weakViewWrapper = WeakViewWrapper(newValue)
                objc_setAssociatedObject(self, &viewAssociationKey, weakViewWrapper, .OBJC_ASSOCIATION_RETAIN)
            } else {
                weakViewWrapper!.view = newValue
            }
        }
    }
    
    internal var actionHandler: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &handlerAssociationKey)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &handlerAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    internal convenience init(view: UIView) {
        self.init()
        self.referenceView = view
    }
    
    /// Keeps a weak reference to a view. Used to work around the limitation that extensions cannot have stored
    /// properties and objc_setAssociatedObject does not support zeroing weak references. See
    /// [on Stack Overflow](http://stackoverflow.com/questions/27632867/how-do-i-create-a-weak-stored-property-in-a-swift-extension)
    internal class WeakViewWrapper : NSObject {
        weak var view : UIView?
        
        init(_ view: UIView?) {
            self.view = view
        }
    }
}


public typealias TapAction = (location: C4Point, state: UIGestureRecognizerState) -> ()

extension UITapGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var tapAction: TapAction? {
        get {
            return (actionHandler as? TapGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                removeTarget(handler, action: "handleGesture:")
            }
            
            if let action = newValue {
                actionHandler = TapGestureHandler(action)
                addTarget(actionHandler!, action: "handleGesture:")
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: UIView, action: TapAction) {
        self.init()
        self.referenceView = view
        self.tapAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class TapGestureHandler : NSObject {
        let action: TapAction
        
        init(_ action: TapAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
            action(location: gestureRecognizer.location, state: gestureRecognizer.state)
        }
    }
}


public typealias PanAction = (location: C4Point, translation: C4Vector, velocity: C4Vector, state: UIGestureRecognizerState) -> ()

extension UIPanGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var panAction: PanAction? {
        get {
            return (actionHandler as? PanGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                removeTarget(handler, action: "handleGesture:")
            }
            
            if let action = newValue {
                actionHandler = PanGestureHandler(action)
                addTarget(actionHandler!, action: "handleGesture:")
            } else {
                actionHandler = nil
            }
        }
    }

    /// The translation of the pan gesture in the coordinate system of the specified view.
    ///
    /// The x and y values report the total translation over time. They are not delta values from the last time that the translation was reported. Apply the translation value to the state of the view when the gesture is first recognized—do not concatenate the value each time the handler is called.
    public var translation: C4Vector {
        get {
            if let view = referenceView {
                return C4Vector(translationInView(view))
            }
            return C4Vector()
        }
    }

    /// The velocity of the pan gesture in the coordinate system of the specified view.
    ///
    /// The velocity of the pan gesture, which is expressed in points per second. The velocity is broken into horizontal and vertical components.
    public var velocity: C4Vector {
        get {
            return C4Vector(velocityInView(view))
        }
        
    }
    
    internal convenience init(view: UIView, action: PanAction) {
        self.init()
        self.referenceView = view
        self.panAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class PanGestureHandler : NSObject {
        let action: PanAction
        
        init(_ action: PanAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
            action(location: gestureRecognizer.location, translation: gestureRecognizer.translation, velocity: gestureRecognizer.velocity, state: gestureRecognizer.state)
        }
    }
}


public typealias PinchAction = (scale: Double, velocity: Double, state: UIGestureRecognizerState) -> ()

extension UIPinchGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var pinchAction: PinchAction? {
        get {
            return (actionHandler as? PinchGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                removeTarget(handler, action: "handleGesture:")
            }
            
            if let action = newValue {
                actionHandler = PinchGestureHandler(action)
                addTarget(actionHandler!, action: "handleGesture:")
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: UIView, action: PinchAction) {
        self.init()
        self.referenceView = view
        self.pinchAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class PinchGestureHandler : NSObject {
        let action: PinchAction
        
        init(_ action: PinchAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: UIPinchGestureRecognizer) {
            action(scale: Double(gestureRecognizer.scale), velocity: Double(gestureRecognizer.velocity), state: gestureRecognizer.state)
        }
    }
}


public typealias RotationAction = (rotation: Double, velocity: Double, state: UIGestureRecognizerState) -> ()

extension UIRotationGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var rotationAction: RotationAction? {
        get {
            return (actionHandler as? RotationGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                removeTarget(handler, action: "handleGesture:")
            }
            
            if let action = newValue {
                actionHandler = RotationGestureHandler(action)
                addTarget(actionHandler!, action: "handleGesture:")
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: UIView, action: RotationAction) {
        self.init()
        self.referenceView = view
        self.rotationAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class RotationGestureHandler : NSObject {
        let action: RotationAction
        
        init(_ action: RotationAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: UIRotationGestureRecognizer) {
            action(rotation: Double(gestureRecognizer.rotation), velocity: Double(gestureRecognizer.velocity), state: gestureRecognizer.state)
        }
    }
}


public typealias LongPressAction = (location: C4Point, state: UIGestureRecognizerState) -> ()

extension UILongPressGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var longPressAction: LongPressAction? {
        get {
            return (actionHandler as? LongPressGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                removeTarget(handler, action: "handleGesture:")
            }
            
            if let action = newValue {
                actionHandler = LongPressGestureHandler(action)
                addTarget(actionHandler!, action: "handleGesture:")
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: UIView, action: LongPressAction) {
        self.init()
        self.referenceView = view
        self.longPressAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class LongPressGestureHandler : NSObject {
        let action: LongPressAction
        
        init(_ action: LongPressAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: UILongPressGestureRecognizer) {
            action(location: gestureRecognizer.location, state: gestureRecognizer.state)
        }
    }
}


public typealias SwipeAction = (location: C4Point, state: UIGestureRecognizerState, direction: UISwipeGestureRecognizerDirection) -> ()

extension UISwipeGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var swipeAction: SwipeAction? {
        get {
            return (actionHandler as? SwipeGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                removeTarget(handler, action: "handleGesture:")
            }
            
            if let action = newValue {
                actionHandler = SwipeGestureHandler(action)
                addTarget(actionHandler!, action: "handleGesture:")
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: UIView, action: SwipeAction) {
        self.init()
        self.referenceView = view
        self.swipeAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class SwipeGestureHandler : NSObject {
        let action: SwipeAction
        
        init(_ action: SwipeAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: UISwipeGestureRecognizer) {
            action(location: gestureRecognizer.location, state: gestureRecognizer.state, direction: gestureRecognizer.direction)
        }
    }
}


public typealias ScreenEdgePanAction = (location: C4Point, state: UIGestureRecognizerState) -> ()

extension UIScreenEdgePanGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var screenEdgePanAction: ScreenEdgePanAction? {
        get {
            return (actionHandler as? ScreenEdgePanGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                removeTarget(handler, action: "handleGesture:")
            }
            
            if let action = newValue {
                actionHandler = ScreenEdgePanGestureHandler(action)
                addTarget(actionHandler!, action: "handleGesture:")
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: UIView, action: ScreenEdgePanAction) {
        self.init()
        self.referenceView = view
        self.screenEdgePanAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class ScreenEdgePanGestureHandler : NSObject {
        let action: ScreenEdgePanAction
        
        init(_ action: ScreenEdgePanAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
            action(location: gestureRecognizer.location, state: gestureRecognizer.state)
        }
    }
}
