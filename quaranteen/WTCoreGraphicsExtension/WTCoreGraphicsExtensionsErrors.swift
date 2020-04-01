/*
 WTCoreGraphicsExtensionsError.swift
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


/// An enumeration describing the possible errors that can be thrown when
/// using functions from the extended `CGPoint` and `CGVector` APIs provided
/// by **WTCoreGraphicsExtensions**.
///
/// - **negativeTolerance**:
///            Signifies that the function throwing the error expected
///            a non-negative `tolerance` value but was provided with
///            a negative one.
///
/// - **notNormalizable**:
///            Signifies that the attempted function could not be performed
///            because the `CGVector` instance on which it would operate is
///            not normalizable (ie, is the zero vector).
///
/// - **negativeMagnitude**:
///            Signifies that the attempted function expected a non-negative
///            value for the `magnitude` argument but was passed a negative one.
///
/// - **divisionByZero**:
///            Signifies that an attempt was performed to divide a value by zero.
public enum WTCoreGraphicsExtensionsError: Error
{
    case negativeTolerance
    case negativeMagnitude
    case notNormalizable
    case divisionByZero
}
