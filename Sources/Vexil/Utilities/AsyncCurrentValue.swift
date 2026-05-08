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

struct AsyncCurrentValue<Wrapped: Sendable> {

    struct State {
        // iterators start with generation = 0, so our initial value
        // has generation 1, so even that will be delivered.
        var generation = 1
        var wrappedValue: Wrapped
        var pendingContinuations = [(UUID, CheckedContinuation<(Int, Wrapped)?, Never>)]()
    }

    final class Allocation: Sendable {
        let mutex: Mutex<State>

        init(state: sending State) {
            self.mutex = Mutex(state)
        }
    }

    // MARK: - Properties

    let allocation: Allocation

    // get-only; providing set would encourage `currentValue += 1`
    // which is a race (lock taken twice). Use
    // `$currentValue.update { $0 += 1 }` instead.

    /// Access to the current value.
    var value: Wrapped {
        allocation.mutex.withLock { $0.wrappedValue }
    }

    // MARK: - Initialisation

    /// Creates a `CurrentValue` with an initial value
    init(_ initialValue: sending Wrapped) {
        self.allocation = .init(state: State(wrappedValue: initialValue))
    }

    // MARK: - Mutation

    /// Updates the current state using the supplied closure.
    ///
    /// - Parameters:
    ///   - body:               A closure that passes the current value as an in-out parameter that you can mutate.
    ///                         When the closure returns the mutated value is saved as the current value and is sent to all subscribers.
    ///
    func update<R: Sendable, E: Error>(_ body: (inout sending Wrapped) throws(E) -> R) throws(E) -> R {
        let result: Result<R, E>
        let generation: Int
        let pendingContinuations: [CheckedContinuation<(Int, Wrapped)?, Never>]
        let updatedValue: Wrapped

        // If we resume continuations within the context of this lock we risk a deadlock
        // as they attempt to access the next value. So we do the update and return
        // pending continuations to be resumed outside the lock. It should be impossible
        // for new continuations to miss this generation as they're accessed and added
        // within the same lock closure.

        (result, updatedValue, generation, pendingContinuations) = allocation.mutex.withLock { state in

            // The closure mutates a copy, then we save that back to our state
            var wrappedValue = state.wrappedValue
            let result = Result { () throws(E) -> R in
                try body(&wrappedValue)
            }
            state.wrappedValue = wrappedValue

            // Bump generation and grab pending continuations
            state.generation += 1
            let toResume = state.pendingContinuations.map(\.1)
            state.pendingContinuations = []
            return (result, wrappedValue, state.generation, toResume)
        }

        // Resume our pending continuations
        for continuation in pendingContinuations {
            continuation.resume(returning: (generation, updatedValue))
        }
        return try result.get()
    }

}

extension AsyncCurrentValue<FlagChange> {
    var stream: FlagChangeStream {
        FlagChangeStream(allocation: allocation)
    }
}
