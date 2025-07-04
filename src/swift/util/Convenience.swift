/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import WCDB_Author

internal extension Array {
    func joined(_ map: (Element) -> String, separateBy separator: String = ", ") -> String {
        var flag = false
        return reduce(into: "") { (output, element) in
            if flag {
                output.append(separator)
            } else {
                flag = true
            }
            output.append(map(element))
        }
    }
}

internal extension Array where Element: StringProtocol {
    func joined(separateBy separator: String = ", ") -> String {
        var flag = false
        return reduce(into: "") { (output, element) in
            if flag {
                output.append(separator)
            } else {
                flag = true
            }
            output.append(String(element))
        }
    }
}

internal extension Array where Element: Describable {
    func joined(separateBy separator: String = ", ") -> String {
        return joined({ $0.description }, separateBy: separator)
    }
}

internal extension Array where Element==PropertyConvertible {
    func asCodingTableKeys() -> [CodingTableKeyBase] {
        return reduce(into: [CodingTableKeyBase]()) { (result, element) in
            assert(element.codingTableKey != nil, "CodingTableKey should not be failed. If you think it's a bug, please report an issue to us.")
            result.append(element.codingTableKey!)
        }
    }
#if WCDB_SWIFT_BRIDGE_OBJC
    func asWCTBridgeProperties() -> [WCTBridgeProperty] {
        return reduce(into: [WCTBridgeProperty]()) { (result, element) in
            assert(element.wctProperty != nil, "WCTProperty should not be failed. If you think it's a bug, please report an issue to us.")
            result.append(element.wctProperty!)
        }
    }
#endif
}

internal extension Array where Element: PropertyConvertible {
    func asCodingTableKeys() -> [CodingTableKeyBase] {
        return reduce(into: [CodingTableKeyBase]()) { (result, element) in
            assert(element.codingTableKey != nil, "CodingTableKey should not be failed. If you think it's a bug, please report an issue to us.")
            result.append(element.codingTableKey!)
        }
    }
#if WCDB_SWIFT_BRIDGE_OBJC
    func asWCTBridgeProperties() -> [WCTBridgeProperty] {
        return reduce(into: [WCTBridgeProperty]()) { (result, element) in
            assert(element.wctProperty != nil, "WCTProperty should not be failed. If you think it's a bug, please report an issue to us.")
            result.append(element.wctProperty!)
        }
    }
#endif
}

internal extension Array {
    mutating func expand(toNewSize newSize: Int, fillWith value: Iterator.Element) {
        if count < newSize {
            append(contentsOf: repeatElement(value, count: count.distance(to: newSize)))
        }
    }
}

internal extension Array where Iterator.Element: FixedWidthInteger {
    mutating func expand(toNewSize newSize: Int) {
        expand(toNewSize: newSize, fillWith: 0)
    }
}

internal extension Dictionary {
    func joined(_ map: (Key, Value) -> String, separateBy separator: String = "," ) -> String {
        var flag = false
        return reduce(into: "", { (output, arg) in
            if flag {
                output.append(separator)
            } else {
                flag = true
            }
            output.append(map(arg.key, arg.value))
        })
    }
}

internal extension String {
    var lastPathComponent: String {
        return URL(fileURLWithPath: self).lastPathComponent
    }

    func stringByAppending(pathComponent: String) -> String {
        return URL(fileURLWithPath: self).appendingPathComponent(pathComponent).path
    }

    var cString: UnsafePointer<Int8>? {
        return UnsafePointer<Int8>((self as NSString).utf8String)
    }

    init?(bytes: UnsafeRawPointer, count: Int, encoding: String.Encoding) {
        self.init(data: Data(bytes: bytes, count: count), encoding: encoding)
    }

    func range(from begin: Int, to end: Int) -> Range<String.Index> {
        return index(startIndex, offsetBy: begin)..<index(startIndex, offsetBy: end)
    }

    func range(location: Int, length: Int) -> Range<String.Index> {
        return range(from: location, to: location + length)
    }
}

internal extension Bool {
    @inline(__always) func toInt32() -> Int32 {
        return self ? 1 : 0
    }
}

internal extension Int {
    @inline(__always) func toInt64() -> Int64 {
        return Int64(self)
    }
}

internal extension Int8 {
    @inline(__always) func toInt32() -> Int32 {
        return Int32(self)
    }
}

internal extension Int16 {
    @inline(__always) func toInt32() -> Int32 {
        return Int32(self)
    }
}

internal extension Int32 {
    @inline(__always) func toBool() -> Bool {
        return self != 0
    }
    @inline(__always) func toInt8() -> Int8 {
        return Int8(truncatingIfNeeded: self)
    }
    @inline(__always) func toInt16() -> Int16 {
        return Int16(truncatingIfNeeded: self)
    }
    @inline(__always) func toUInt8() -> UInt8 {
        return UInt8(bitPattern: Int8(truncatingIfNeeded: self))
    }
    @inline(__always) func toUInt16() -> UInt16 {
        return UInt16(bitPattern: Int16(truncatingIfNeeded: self))
    }
    @inline(__always) func toUInt32() -> UInt32 {
        return UInt32(bitPattern: self)
    }
}

internal extension Int64 {
    @inline(__always) func toInt() -> Int {
        return Int(truncatingIfNeeded: self)
    }
    @inline(__always) func toUInt() -> UInt {
        return UInt(bitPattern: Int(truncatingIfNeeded: self))
    }
    @inline(__always) func toUInt64() -> UInt64 {
        return UInt64(bitPattern: self)
    }
}

internal extension UInt {
    @inline(__always) func toInt64() -> Int64 {
        return Int64(bitPattern: UInt64(self))
    }
}

internal extension UInt8 {
    @inline(__always) func toInt32() -> Int32 {
        return Int32(bitPattern: UInt32(self))
    }
}

internal extension UInt16 {
    @inline(__always) func toInt32() -> Int32 {
        return Int32(bitPattern: UInt32(self))
    }
}

internal extension UInt32 {
    @inline(__always) func toInt32() -> Int32 {
        return Int32(bitPattern: self)
    }
}

internal extension UInt64 {
    @inline(__always) func toInt64() -> Int64 {
        return Int64(bitPattern: self)
    }
}

internal extension Float {
    @inline(__always) func toDouble() -> Double {
        return Double(self)
    }
}

internal extension Double {
    @inline(__always) func toFloat() -> Float {
        return Float(self)
    }
}
