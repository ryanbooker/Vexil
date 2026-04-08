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

struct FlagPoleTests {


#if !os(Linux)

    @Test(.tags(.pole))
    func `Sets default sources`() throws {
        let pole = FlagPole(hoist: TestFlags.self)

        #expect(pole._sources.count == 1)
        let coordinator = try #require(pole._sources.first as? FlagValueSourceCoordinator<UserDefaults>)
        coordinator.source.withLock {
            #expect($0 === UserDefaults.standard)
        }
    }

#else

    @Test(.tags(.pole))
    func `sets default sources`() {
        let pole = FlagPole(hoist: TestFlags.self)
        #expect(pole._sources.isEmpty)
    }

#endif

}

// MARK: - Fixtures

@FlagContainer(generateEquatable: false)
private struct TestFlags {}
