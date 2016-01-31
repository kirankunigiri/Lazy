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
import CoreGraphics

///C4Line is a is a concrete subclass of C4Polygon that contains only two points.
///
///This subclass overrides the `points` variable so that it can only ever have 2 points, and also has an `endPoints` variable that allows the user to edit either end of the line (animatable).
public class C4Line: C4Polygon {

    /// The end points the receiver's line. Animatable.
    ///
    /// Assigning a tuple of C4Point values to this object will cause the receiver to update itself.
    ///
    /// - returns: A tuple (2) of C4Points that make up the the begin and end points of the line.
    public var endPoints: (C4Point,C4Point) = (C4Point(),C4Point(100,0)){
        didSet {
            updatePath()
        }
    }

    override func updatePath() {
        if pauseUpdates {
            return
        }

        let p = C4Path()
        p.moveToPoint(endPoints.0)
        p.addLineToPoint(endPoints.1)
        path = p
        adjustToFitPath()
    }

    /// The center point (top-left) of the receiver's frame. Animatable.
    ///
    /// - returns: A C4Point, the receiver's center.
    public override var center : C4Point {
        get {
            return C4Point(view.center)
        }
        set {
            let diff = newValue - center
            batchUpdates() {
                self.endPoints.0 += diff
                self.endPoints.1 += diff
            }
        }
    }

    /// The origin point (top-left) of the receiver's frame. Animatable.
    ///
    /// - returns: A C4Point, the receiver's origin.
    public override var origin : C4Point {
        get {
            return C4Point(view.frame.origin)
        }
        set {
            let diff = newValue - origin
            batchUpdates() {
                self.endPoints.0 += diff
                self.endPoints.1 += diff
            }
        }
    }

    /// The points that make up the line. Animatable.
    ///
    /// Assigning an array of C4Point values to this object will cause the receiver to update itself.
    ///
    /// - returns: A C4Point array of 2 points.
    public override var points : [C4Point] {
        get {
            return [endPoints.0,endPoints.1]
        } set {
            if newValue.count < 2 {
                print("Invalid point array. There must be at least 2 points to update the line.")
            } else {
                if newValue.count > 2 {
                    print("Warning. The passed array has more than 2 points, only the first two will be used.")
                }
                batchUpdates() {
                    self.endPoints.0 = newValue[0]
                    self.endPoints.1 = newValue[1]
                }
            }
        }
    }

    /// Initializes a new C4Polygon using the specified array of points.
    ///
    /// Protects against trying to create a polygon with only 1 point (i.e. requires 2 points).
    /// Trims point array if count > 2.
    ///
    /// ````
    /// let a = C4Point(100,100)
    /// let b = C4Point(200,200)
    ///
    /// let l = C4Line([a,b])
    /// ````
    ///
    /// - parameter points: An array of C4Point structs.
    public override init(_ points: [C4Point]) {
        let firstTwo = [C4Point](points[0...1])
        super.init(firstTwo)

        let path = C4Path()
        path.moveToPoint(points[0])
        for i in 1..<points.count {
            path.addLineToPoint(points[i])
        }

        adjustToFitPath()
    }

    /// Initializes a new C4Line using the specified tuple of points.
    ///
    /// ````
    /// let a = C4Point(100,100)
    /// let b = C4Point(200,200)
    ///
    /// let l = C4Line((a,b))
    /// ````
    ///
    /// - parameter points: A tuple of C4Point structs.
    public init(_ points: (C4Point, C4Point)) {
        self.endPoints = points
        super.init([points.0, points.1])
    }
    
    /// Initializes a new C4Line using two specified points.
    ///
    /// ````
    /// let a = C4Point(100,100)
    /// let b = C4Point(200,200)
    ///
    /// let l = C4Line(begin: a, end: b)
    /// ````
    ///
    /// - parameter begin: The start point of the line.
    /// - parameter end: The end point of the line.
    public convenience init(begin: C4Point, end: C4Point) {
        let points = (begin, end)
        self.init(points)
    }

    ///Returns an object initialized from data in a given unarchiver.
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var pauseUpdates = false
    func batchUpdates(updates: Void -> Void) {
        pauseUpdates = true
        updates()
        pauseUpdates = false
        updatePath()
    }
}
