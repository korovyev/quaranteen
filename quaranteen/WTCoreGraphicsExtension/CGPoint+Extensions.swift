/*
 CGPoint+extensions.swift
 WTCoreGraphicsExtensions
 Created by Wagner Truppel on 2016.12.03.
 The MIT License (MIT)
 Copyright (c) 2016 Wagner Truppel.
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 When crediting me (Wagner Truppel) for this work, please use one
 of the following two suggested formats:
 Uses "WTCoreGraphicsExtensions" by Wagner Truppel
 https://github.com/wltrup
 or
 WTCoreGraphicsExtensions by Wagner Truppel
 https://github.com/wltrup
 */

import CoreGraphics


// MARK: - Instance creation and initializers
extension CGPoint
{
    /// Initializes `self` with the given `Float` components.
    ///
    /// - Parameters:
    ///   - x: any `Float` value.
    ///   - y: any `Float` value.
    public init(x: Float, y: Float)
    {
        self.init()
        self.x = CGFloat(x)
        self.y = CGFloat(y)
    }

    /// Returns an instance where each component is a uniform pseudo-random
    /// number in the **closed** interval [min(a,b), max(a,b)].
    ///
    /// - Parameters:
    ///   - a: any `CGFloat` value.
    ///   - b: any `CGFloat` value.
    ///
    /// - Returns: an instance where each component is a uniform pseudo-random
    ///            number in the **closed** interval [min(a,b), max(a,b)].
    public static func random(_ a: CGFloat, _ b: CGFloat) -> CGPoint
    {
        let x = CGFloat.random(in: a...b)
        let y = CGFloat.random(in: a...b)
        return CGPoint(x: x, y: y)
    }
}

// MARK: - Equality
extension CGPoint
{
    /// Returns whether or not `self` equals another point, within a given
    /// tolerance. More specifically, returns whether or not the magnitude
    /// of the difference between the two points is within the given tolerance.
    /// For exact comparisons, pass `0` for the `tolerance` value, or use the
    /// `==` operator.
    ///
    /// - Parameters:
    ///   - other: any `CGPoint` instance.
    ///   - tolerance: a small non-negative value.
    ///                The default value is `CGFloat.tolerance`.
    ///
    /// - Returns: whether or not `self` equals another point, within the
    ///            given tolerance.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeTolerance`
    ///           if `tolerance` is negative.
    ///
    /// - SeeAlso: `isNearlyZero(tolerance:)`.
    public func isNearlyEqual(to other: CGPoint,
                              tolerance: CGFloat = CGFloat.tolerance) throws -> Bool
    {
        if tolerance == 0 { return (self == other) }
        guard tolerance > 0 else { throw WTCoreGraphicsExtensionsError.negativeTolerance }
        return distanceSquared(to: other) <= tolerance*tolerance
    }

    /// Returns whether or not `self` equals the zero point, within a given
    /// tolerance. More specifically, returns whether or not the magnitude
    /// of `self` is within the given tolerance. For exact comparisons, pass
    /// `0` for the `tolerance` value, or use the `==` operator.
    ///
    /// - Parameter tolerance: a small non-negative value.
    ///                        The default value is `CGFloat.tolerance`.
    ///
    /// - Returns: whether or not `self` equals the zero point, within the
    ///            given tolerance.
    ///
    /// - Throws: `WTCoreGraphicsExtensionsError.negativeTolerance`
    ///           if `tolerance` is negative.
    ///
    /// - SeeAlso: `isNearlyEqual(to:tolerance:)`.
    public func isNearlyZero(tolerance: CGFloat = CGFloat.tolerance) throws -> Bool
    { return try isNearlyEqual(to: CGPoint.zero, tolerance: tolerance) }
}

// MARK: - Metric properties
extension CGPoint
{
    /// Returns the
    /// [**Euclidean distance**](https://en.wikipedia.org/wiki/Euclidean_distance)
    /// between `self` and another point.
    ///
    /// - Parameter other: any `CGPoint` instance.
    ///
    /// - Returns: the Euclidean distance between `self` and another point.
    ///
    /// - SeeAlso: `distanceSquared(to:)`.
    public func distance(to other: CGPoint) -> CGFloat
    { return vector(to: other).magnitude }

    /// Returns the **square** of the
    /// [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance)
    /// between `self` and another point. This is more efficient than calling
    /// `distance(to:)` and then squaring.
    ///
    /// - Parameter other: any `CGPoint` instance.
    ///
    /// - Returns: the square of the Euclidean distance between `self`
    ///            and another point.
    ///
    /// - SeeAlso: `distance(to:)`.
    public func distanceSquared(to other: CGPoint) -> CGFloat
    { return vector(to: other).magnitudeSquared }

    /// Returns the
    /// [**Manhattan distance**](https://en.wikipedia.org/wiki/Taxicab_geometry)
    /// between `self` and another point. The Manhattan distance is also known as
    /// the **Taxicab distance**.
    ///
    /// - Parameter other: any `CGPoint` instance.
    ///
    /// - Returns: the Manhattan distance between `self` and another point.
    ///
    /// - SeeAlso: `distance(to:)`.
    /// - SeeAlso: `distanceSquared(to:)`.
    public func manhattanDistance(to other: CGPoint) -> CGFloat
    { return vector(to: other).manhattanMagnitude }
}

// MARK: - Vectors
extension CGPoint
{
    /// Returns the vector pointing from `self` to another point.
    ///
    /// - Parameter other: any `CGPoint` instance.
    ///
    /// - Returns: the vector pointing **from** `self` **to** another point.
    ///
    /// - SeeAlso: `vector(from:)`.
    /// - SeeAlso: `CGPoint.vector(from:to:)`.
    public func vector(to other: CGPoint) -> CGVector
    {
        let dx = other.x - self.x
        let dy = other.y - self.y
        return CGVector(dx: dx, dy: dy)
    }

    /// Returns the vector pointing to `self` from another point.
    ///
    /// - Parameter other: any `CGPoint` instance.
    ///
    /// - Returns: the vector pointing **to** `self` **from** another point.
    ///
    /// - SeeAlso: `vector(to:)`.
    /// - SeeAlso: `CGPoint.vector(from:to:)`.
    public func vector(from other: CGPoint) -> CGVector
    { return other.vector(to: self) }

    /// Returns the vector from one point to another.
    ///
    /// - Parameters:
    ///   - point1: any `CGPoint` instance.
    ///   - point2: any `CGPoint` instance.
    ///
    /// - Returns: the vector from one point to another.
    ///
    /// - SeeAlso: `vector(to:)`.
    /// - SeeAlso: `vector(from:)`.
    public static func vector(from point1: CGPoint, to point2: CGPoint) -> CGVector
    { return point1.vector(to: point2) }
}

// MARK: - Operators
extension CGPoint
{
    /// Adds a vector to a point, resulting in a point.
    ///
    /// - Parameters:
    ///   - lhs: the point.
    ///   - rhs: the vector.
    ///
    /// - Returns: the point resulting from adding the vector to the point.
    public static func +(lhs: CGPoint, rhs: CGVector) -> CGPoint
    {
        let x = lhs.x + rhs.dx
        let y = lhs.y + rhs.dy
        return CGPoint(x: x, y: y)
    }

    /// Subtracts a vector from a point, resulting in a point.
    ///
    /// - Parameters:
    ///   - lhs: the point.
    ///   - rhs: the vector.
    ///
    /// - Returns: the point resulting from subtracting the vector from the point.
    public static func -(lhs: CGPoint, rhs: CGVector) -> CGPoint
    {
        let x = lhs.x - rhs.dx
        let y = lhs.y - rhs.dy
        return CGPoint(x: x, y: y)
    }

    /// Subtracts two points, resulting in a vector pointing from `rhs` to `lhs`.
    ///
    /// - Parameters:
    ///   - lhs: any `CGPoint` instance.
    ///   - rhs: any `CGPoint` instance.
    ///
    /// - Returns: the vector resulting from subtracting a point from another point.
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGVector
    { return rhs.vector(to: lhs) }

    /// Adds a vector to the point `self`.
    ///
    /// - Parameters:
    ///   - lhs: the point.
    ///   - rhs: the vector.
    public static func +=(lhs: inout CGPoint, rhs: CGVector)
    { lhs = lhs + rhs }

    /// Subtracts a vector from the point `self`.
    ///
    /// - Parameters:
    ///   - lhs: the point.
    ///   - rhs: the vector.
    public static func -=(lhs: inout CGPoint, rhs: CGVector)
    { lhs = lhs - rhs }
}
