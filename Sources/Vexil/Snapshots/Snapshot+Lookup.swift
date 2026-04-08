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

// #if !os(Linux)
// import Combine
// #endif

extension Snapshot: FlagLookup {

    public func value<Value: FlagValue>(for keyPath: FlagKeyPath) -> Value? {
        values.withLock {
            $0[keyPath.key] as? Value
        }
    }

    public var changes: FlagChangeStream {
        stream.stream
    }

}
