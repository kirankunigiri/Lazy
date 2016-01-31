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

///  C4Polygon is a concrete subclass of C4Shape that has a special initialzer that creates a non-uniform shape made up of 3 or more points.
public class C4Polygon: C4Shape {
    
    /// Returns the array of points that make up the polygon.
    ///
    /// Assigning an array of C4Point values to this object will cause the receiver to update itself.
    ///
    /// ````
    /// let p = C4Polygon()
    /// let a = C4Point()
    /// let b = C4Point(100,100)
    /// let c = C4Point(200,0)
    /// p.points = [a,b,c]
    /// p.center = canvas.center
    /// canvas.add(p)
    /// ````
    public var points: [C4Point] {
        didSet {
            updatePath()
        }
    }

    ///  Initializes a default C4Polygon.
    override init() {
        self.points = []
        super.init()
        fillColor = clear
    }
    
    /// Initializes a new C4Polygon using the specified array of points.
    ///
    /// Protects against trying to create a polygon with only 1 point (i.e. requires 2 or more points).
    ///
    /// ````
    /// let a = C4Point()
    /// let b = C4Point(100,100)
    /// let c = C4Point(200,0)
    /// let p = C4Polygon([a,b,c])
    /// p.center = canvas.center
    /// canvas.add(p)
    /// ````
    /// - parameter points: An array of C4Point structs.
    public init(_ points: [C4Point]) {
        assert(points.count >= 2, "To create a Polygon you need to specify an array of at least 2 points")
        self.points = points
        super.init()

        fillColor = clear

        let path = C4Path()
        path.moveToPoint(points[0])
        for i in 1..<points.count {
            path.addLineToPoint(points[i])
        }
        self.path = path

        adjustToFitPath()
    }

    /// Initializes a new C4Polygon from data in a given unarchiver.
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updatePath() {
        if points.count > 1 {
            let p = C4Path()
            p.moveToPoint(points[0])
            
            for i in 1..<points.count {
                p.addLineToPoint(points[i])
            }
            
            path = p
            adjustToFitPath()
        }
    }

    ///  Closes the shape.
    ///
    ///  This method appends a line between the shape's last point and its first point.
    public func close() {
        let p = path
        p?.closeSubpath()
        self.path = p
        adjustToFitPath()
    }
}