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

import Foundation
import Testing
@testable import Vexil

@Suite(.tags(.boxing))
struct FlagValueBoxingTests {

    // MARK: - Boolean Flag Values

    @Test
    func `Boxes boolean true`() {
        #expect(true.boxedFlagValue == .bool(true))
    }

    @Test
    func `Boxes boolean false`() {
        #expect(false.boxedFlagValue == .bool(false))
    }


    // MARK: - String Flag Values

    @Test
    func `Boxes string`() {
        #expect("Test String".boxedFlagValue == .string("Test String"))
    }

    @Test
    func `Boxes URL`() {
        #expect(URL(string: "https://google.com/")?.boxedFlagValue == .string("https://google.com/"))
    }


    // MARK: - Data and Date Types

    @Test
    func `Boxes data`() {
        #expect(Data("Test string".utf8).boxedFlagValue == .data(Data("Test string".utf8)))
    }

    @Test
    func `Boxes date`() {
        let input = Date()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [ .withInternetDateTime, .withFractionalSeconds ]

        #expect(input.boxedFlagValue == .string(formatter.string(from: input)))
    }


    // MARK: - Integer Flag Values

    @Test
    func `Boxes integer`() {
        #expect(123.boxedFlagValue == .integer(123))
    }

    @Test
    func `Boxes 8-bit integer`() {
        #expect(Int8(12).boxedFlagValue == .integer(12))
    }

    @Test
    func `Boxes 16-bit integer`() {
        #expect(Int16(123).boxedFlagValue == .integer(123))
    }

    @Test
    func `Boxes 32-bit integer`() {
        #expect(Int32(123).boxedFlagValue == .integer(123))
    }

    @Test
    func `Boxes 64-bit integer`() {
        #expect(Int64(123).boxedFlagValue == .integer(123))
    }

    @Test
    func `Boxes unsigned integer`() {
        #expect(UInt(123).boxedFlagValue == .integer(123))
    }

    @Test
    func `Boxes 8-bit unsigned integer`() {
        #expect(UInt8(123).boxedFlagValue == .integer(123))
    }

    @Test
    func `Boxes 16-bit unsigned integer`() {
        #expect(UInt16(123).boxedFlagValue == .integer(123))
    }

    @Test
    func `Boxes 32-bit unsigned integer`() {
        #expect(UInt32(123).boxedFlagValue == .integer(123))
    }

    @Test
    func `Boxes 64-bit unsigned integer`() {
        #expect(UInt64(123).boxedFlagValue == .integer(123))
    }


    // MARK: - Floating Point Flag Values

    @Test
    func `Boxes float`() {
        #expect(Float(123.456).boxedFlagValue == .float(123.456))
    }

    @Test
    func `Boxes double`() {
        #expect(123.456.boxedFlagValue == .double(123.456))
    }


    // MARK: - Wrapping Types

    @Test
    func `Boxes raw representable`() {
        #expect(TestStruct(rawValue: 123).boxedFlagValue == .integer(123))

        struct TestStruct: RawRepresentable, FlagValue, Equatable {
            let rawValue: Int
        }
    }

    @Test
    func `Boxes optional`() {
        #expect(Int?.some(123)?.boxedFlagValue == .integer(123))
    }

    @Test
    func `Boxes nil`() {
        #expect(Int?.none.boxedFlagValue == BoxedFlagValue.none)
    }


    // MARK: - Collection Types

    @Test
    func `Boxes array`() {
        #expect([ 123, 456, 789 ].boxedFlagValue == .array([ .integer(123), .integer(456), .integer(789) ]))
    }

    @Test
    func `Boxes dictionary`() {
        #expect(
            [ "one": 123, "two": 456, "three": 789 ].boxedFlagValue
                == .dictionary([ "one": .integer(123), "two": .integer(456), "three": .integer(789) ]),
        )
    }


    // MARK: - Codable Types

    @Test(.tags(.codable))
    func `Boxes codable`() throws {
        let input = TestStruct()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let expected = try encoder.encode(Wrapper(wrapped: input))

        #expect(input.boxedFlagValue == .data(expected))

        struct TestStruct: Codable, FlagValue, Equatable {
            let property1: Int
            let property2: String
            let property3: Double

            init() {
                self.property1 = 123
                self.property2 = "456"
                self.property3 = 789.0
            }
        }
    }

}
