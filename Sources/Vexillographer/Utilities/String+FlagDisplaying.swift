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

import Vexil

extension String {

    /// Creates the string Vexillographer draws for a flag value.
    ///
    /// A type customises what the editor shows by conforming to `FlagDisplayValue`,
    /// so ask it first and describe the value only where it does not conform, which
    /// is where the case name is the best we can do.
    init(flagDisplaying value: Any) {
        if let value = value as? any FlagDisplayValue {
            self = value.flagDisplayValue
        } else {
            self = String(describing: value)
        }
    }

}
