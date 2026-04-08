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

@Suite(.tags(.boxing, .codable))
struct BoxedFlagValueEncodingTests {

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [ .sortedKeys ]
        encoder.dataEncodingStrategy = .base64
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }()


    // MARK: - Boolean Flag Values

    @Test
    func `Encodes boolean true`() throws {
        let input = BoxedFlagValue.bool(true)
        let expected = #"{"b":true}"#.utf8
        let encoded = try encoder.encode(input)
        #expect(encoded == Data(expected))
    }

    @Test
    func `Encodes boolean false`() throws {
        let input = BoxedFlagValue.bool(false)
        let expected = #"{"b":false}"#.utf8
        let encoded = try encoder.encode(input)
        #expect(encoded == Data(expected))
    }


    // MARK: - String Flag Values

    @Test
    func `Encodes string`() throws {
        let input = BoxedFlagValue.string("Test String")
        let expected = #"{"s":"Test String"}"#.utf8
        let encoded = try encoder.encode(input)
        #expect(encoded == Data(expected))
    }


    // MARK: - Data Values

    @Test
    func `Encodes data`() throws {
        let input = BoxedFlagValue.data(Data("Test string".utf8))
        let expected = #"{"d":"VGVzdCBzdHJpbmc="}"#.utf8
        let encoded = try encoder.encode(input)
        #expect(encoded == Data(expected))
    }


    // MARK: - Number Flag Values

    @Test
    func `Encodes integer`() throws {
        let input = BoxedFlagValue.integer(1234)
        let expected = #"{"i":1234}"#.utf8
        let encoded = try encoder.encode(input)
        #expect(encoded == Data(expected))
    }

    @Test
    func `Encodes double`() throws {
        let input = BoxedFlagValue.double(123.456)
        let expected = #"{"r":123.456}"#.utf8
        let encoded = try encoder.encode(input)
        #expect(encoded == Data(expected))
    }

    @Test
    func `Encodes float`() throws {
        let input = BoxedFlagValue.float(123.456)
        let expected = #"{"f":123.456}"#.utf8
        let encoded = try encoder.encode(input)
        #expect(encoded == Data(expected))
    }


    // MARK: - Wrapping Types

    @Test
    func `Encodes nil`() throws {
        let input = BoxedFlagValue.none
        let expected = #"{"n":null}"#.utf8
        let encoded = try encoder.encode(input)
        #expect(encoded == Data(expected))
    }


    // MARK: - Collection Types

    @Test
    func `Encodes array`() throws {
        let input = BoxedFlagValue.array([ .integer(123), .integer(456), .integer(789) ])
        let expected = #"{"a":[{"i":123},{"i":456},{"i":789}]}"#.utf8
        let encoded = try encoder.encode(input)
        #expect(encoded == Data(expected))
    }

    @Test
    func `Encodes dictionary`() throws {
        let input = BoxedFlagValue.dictionary([ "one": .integer(123), "two": .integer(456), "three": .integer(789) ])
        let expected = #"{"o":{"one":{"i":123},"three":{"i":789},"two":{"i":456}}}"#.utf8
        let encoded = try encoder.encode(input)
        #expect(encoded == Data(expected))
    }

}
