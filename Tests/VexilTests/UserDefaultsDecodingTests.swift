//===----------------------------------------------------------------------===//
//
// This source file is part of the Vexil open source project
//
// Copyright (c) 2026 Unsigned Apps and the open source contributors.
// Licensed under the MIT license
//
// See LICENSE for license information
//
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//

#if !os(Linux)

import Foundation
import Testing
@testable import Vexil

@Suite(.tags(.userDefaults))
final class UserDefaultsDecodingTests {

    // MARK: - Decoding Missing Values

    @Test
    func `Decodes missing value as nil`() {
        withUserDefaults(#function) { defaults in
            #expect(defaults.flagValue(key: "test") as Bool? == nil)
        }
    }

    @Test
    func `Decodes unset value as nil`() {
        withUserDefaults(#function) { defaults in
            defaults.set(true, forKey: "test")
            defaults.removeObject(forKey: "test")
            #expect(defaults.flagValue(key: "test") as Bool? == nil)
        }
    }


    // MARK: - Decoding Boolean Types

    @Test
    func `Decodes boolean true`() {
        withUserDefaults(#function) { defaults in
            defaults.set(true, forKey: "test")
            #expect(defaults.flagValue(key: "test") == true)
        }
    }

    @Test
    func `Decodes boolean false`() {
        withUserDefaults(#function) { defaults in
            defaults.set(false, forKey: "test")
            #expect(defaults.flagValue(key: "test") == false)
        }
    }

    @Test
    func `Decodes integer as boolean`() {
        withUserDefaults(#function) { defaults in
            defaults.set(1, forKey: "test")
            #expect(defaults.flagValue(key: "test") == true)
        }
    }

    @Test
    func `Decodes double as boolean`() {
        withUserDefaults(#function) { defaults in
            defaults.set(1.0, forKey: "test")
            #expect(defaults.flagValue(key: "test") == true)
        }
    }

    @Test
    func `Decodes string as boolean`() {
        withUserDefaults(#function) { defaults in
            defaults.set("t", forKey: "test")
            #expect(defaults.flagValue(key: "test") == true)
        }
    }


    // MARK: - Decoding String Types

    @Test
    func `Decodes string`() {
        withUserDefaults(#function) { defaults in
            defaults.set("abcd1234", forKey: "test")
            #expect(defaults.flagValue(key: "test") == "abcd1234")
        }
    }

    @Test
    func `Decodes URL`() {
        withUserDefaults(#function) { defaults in
            defaults.set("https://google.com/", forKey: "test")
            #expect(defaults.flagValue(key: "test") == URL(string: "https://google.com/")!)
        }
    }


    // MARK: - Decoding Float / Double Types

    @Test
    func `Decodes double`() {
        withUserDefaults(#function) { defaults in
            defaults.set(123.456, forKey: "test")
            #expect(defaults.flagValue(key: "test") == 123.456)
        }
    }

    @Test
    func `Decodes float`() {
        withUserDefaults(#function) { defaults in
            defaults.set(Float(123.456), forKey: "test")
            #expect(defaults.flagValue(key: "test") == Float(123.456))
        }
    }

    @Test
    func `Decodes integer as double`() {
        withUserDefaults(#function) { defaults in
            defaults.set(1, forKey: "test")
            #expect(defaults.flagValue(key: "test") == 1.0)
        }
    }

    @Test
    func `Decodes string as double`() {
        withUserDefaults(#function) { defaults in
            defaults.set("1.23456789", forKey: "test")
            #expect(defaults.flagValue(key: "test") == 1.23456789)
        }
    }


    // MARK: - Decoding Integer Types

    @Test
    func `Decodes integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set(1234, forKey: "test")
            #expect(defaults.flagValue(key: "test") == 1234)
        }
    }

    @Test
    func `Decodes 8-bit integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set(Int8(12), forKey: "test")
            #expect(defaults.flagValue(key: "test") == Int8(12))
        }
    }

    @Test
    func `Decodes 16-bit integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set(Int16(1234), forKey: "test")
            #expect(defaults.flagValue(key: "test") == Int16(1234))
        }
    }

    @Test
    func `Decodes 32-bit integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set(Int32(1234), forKey: "test")
            #expect(defaults.flagValue(key: "test") == Int32(1234))
        }
    }

    @Test
    func `Decodes 64-bit integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set(Int64(1234), forKey: "test")
            #expect(defaults.flagValue(key: "test") == Int64(1234))
        }
    }

    @Test
    func `Decodes unsigned integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set(UInt(1234), forKey: "test")
            #expect(defaults.flagValue(key: "test") == UInt(1234))
        }
    }

    @Test
    func `Decodes 8-bit unsigned integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set(UInt8(12), forKey: "test")
            #expect(defaults.flagValue(key: "test") == UInt8(12))
        }
    }

    @Test
    func `Decodes 16-bit unsigned integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set(UInt16(1234), forKey: "test")
            #expect(defaults.flagValue(key: "test") == UInt16(1234))
        }
    }

    @Test
    func `Decodes 32-bit unsigned integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set(UInt32(1234), forKey: "test")
            #expect(defaults.flagValue(key: "test") == UInt32(1234))
        }
    }

    @Test
    func `Decodes 64-bit unsigned integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set(UInt64(1234), forKey: "test")
            #expect(defaults.flagValue(key: "test") == UInt64(1234))
        }
    }

    @Test
    func `Decodes string as integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set("1234", forKey: "test")
            #expect(defaults.flagValue(key: "test") == 1234)
        }
    }

    @Test
    func `Decodes string as unsigned integer`() {
        withUserDefaults(#function) { defaults in
            defaults.set("1234", forKey: "test")
            #expect(defaults.flagValue(key: "test") == UInt(1234))
        }
    }


    // MARK: - Wrapping Types

    @Test
    func `Decodes raw representable string`() {
        withUserDefaults(#function) { defaults in
            defaults.set("Test Value", forKey: "test")
            #expect(defaults.flagValue(key: "test") == TestStruct(rawValue: "Test Value"))

            struct TestStruct: RawRepresentable, FlagValue, Equatable {
                var rawValue: String
            }
        }
    }

    @Test
    func `Decodes raw representable boolean`() {
        withUserDefaults(#function) { defaults in
            defaults.set(true, forKey: "test")
            #expect(defaults.flagValue(key: "test") == TestStruct(rawValue: true))

            struct TestStruct: RawRepresentable, FlagValue, Equatable {
                var rawValue: Bool
            }
        }
    }

    // double optionals here because flagValue(key:) returns an optional, so Value is inferred as "String?" or "Bool?"

    @Test
    func `Decodes optional boolean`() {
        withUserDefaults(#function) { defaults in
            defaults.set(true, forKey: "test")
            #expect(defaults.flagValue(key: "test") == Bool??.some(true))
        }
    }

    @Test
    func `Decodes optional string`() {
        withUserDefaults(#function) { defaults in
            defaults.set("Test Value", forKey: "test")
            #expect(defaults.flagValue(key: "test") == String??.some("Test Value"))
        }
    }

    @Test
    func `Decodes nil`() {
        withUserDefaults(#function) { defaults in
            defaults.removeObject(forKey: "test")
            #expect(defaults.flagValue(key: "test") == String??.none)
        }
    }

    @Test
    func `Decodes string as optional boolean`() {
        withUserDefaults(#function) { defaults in
            defaults.set("t", forKey: "test")
            defaults.synchronize()
            #expect(defaults.flagValue(key: "test") == Bool??.some(true))
        }
    }

    // MARK: - Array Tests

    @Test
    func `Decodes string array`() {
        withUserDefaults(#function) { defaults in
            defaults.set([ "abc", "123" ], forKey: "test")
            #expect(defaults.flagValue(key: "test") == [ "abc", "123" ])
        }
    }

    @Test
    func `Decodes integer array`() {
        withUserDefaults(#function) { defaults in
            defaults.set([ 234, -123 ], forKey: "test")
            #expect(defaults.flagValue(key: "test") == [ 234, -123 ])
        }
    }


    // MARK: - Dictionary Tests

    @Test
    func `Decodes string dictionary`() {
        withUserDefaults(#function) { defaults in
            defaults.set([ "key1": "value1", "key2": "value2" ], forKey: "test")
            #expect(defaults.flagValue(key: "test") == [ "key1": "value1", "key2": "value2" ])
        }
    }

    @Test
    func `Decodes integer dictionary`() {
        withUserDefaults(#function) { defaults in
            defaults.set([ "key1": 123, "key2": -987 ], forKey: "test")
            #expect(defaults.flagValue(key: "test") == [ "key1": 123, "key2": -987 ])
        }
    }


    // MARK: - Codable Tests

    @Test
    func `Decodes codable`() {
        struct MyStruct: FlagValue, Codable, Equatable {
            let property1: String
            let property2: Int
            let property3: String

            init() {
                self.property1 = "value1"
                self.property2 = 123
                self.property3 = "🤯"
            }
        }

        let expected = MyStruct()

        // manually encoding into json
        let input =
            """
                {
                    "wrapped": {
                        "property1": "value1",
                        "property2": 123,
                        "property3": "🤯"
                    }
                }
            """

        withUserDefaults(#function) { defaults in
            defaults.set(Data(input.utf8), forKey: "test")
            #expect(defaults.flagValue(key: "test") == expected)
        }
    }

    @Test
    func `Decodes enum`() throws {
        enum MyEnum: String, FlagValue, Equatable {
            case one
            case two
        }

        try withUserDefaults(#function) { defaults in
            try defaults.setFlagValue(MyEnum.one, key: "test")
            #expect(defaults.flagValue(key: "test") == MyEnum.one)
        }
    }

}

/// Swift Testing runs tests inside a TaskGroup, which means sharing UserDefaults across multiple tests is fraught.
private func withUserDefaults(_ suite: String, _ closure: (UserDefaults) throws -> Void) rethrows {
    let defaults = UserDefaults(suiteName: suite)!
    try closure(defaults)
    defaults.removePersistentDomain(forName: suite)
}

#endif // !os(Linux)
