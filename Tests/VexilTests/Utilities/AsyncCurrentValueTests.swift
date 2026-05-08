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

#if os(macOS)

struct AsyncCurrentValueTests {
    /// Regression test for a lock-order inversion deadlock between two threads:
    ///
    ///   Thread A (update): holds allocation.mutex → calls continuation.resume() inside didSet
    ///                      → resume() internally acquires the Swift task status lock
    ///
    ///   Thread B (cancel): acquires the Swift task status lock → fires onCancel: handler
    ///                      → onCancel: calls allocation.mutex.withLock → waits for mutex
    ///
    /// Thread A holds mutex, wants task-lock.
    /// Thread B holds task-lock, wants mutex.
    /// → deadlock.
    ///
    /// If the bug is present, the test will time out after 1 minute.
    @Test(.timeLimit(.minutes(1)))
    func `AsyncCurrentValue does not deadlock when cancellation races a concurrent update`() async {
        for _ in 0 ..< 100_000 {
            let currentValue = AsyncCurrentValue<FlagChange>(.all)

            // This task will:
            //   1. Call next() once — returns the initial value immediately because
            //      iterator.generation (0) < state.generation (1).
            //   2. Call next() again — suspends, storing its continuation in
            //      pendingContinuations. This is the continuation that gets raced.
            let consumingTask = Task {
                var iterator = currentValue.stream.makeAsyncIterator()
                _ = await iterator.next(isolation: nil)
                _ = await iterator.next(isolation: nil)
            }

            // Yield to give the consuming task time to advance past the first next()
            // and park its continuation inside pendingContinuations on the second call.
            await Task.yield()
            await Task.yield()
            await Task.yield()

            // Fire the two racing operations:
            //   updateTask — acquires allocation.mutex, sets wrappedValue, didSet calls
            //                continuation.resume() while still inside withLock.
            //   cancel     — acquires the task status lock, fires onCancel:, which calls
            //                allocation.mutex.withLock.
            let updateTask = Task.detached { currentValue.update { _ in } }
            consumingTask.cancel()

            await updateTask.value
            await consumingTask.value
        }
    }

}

#endif
