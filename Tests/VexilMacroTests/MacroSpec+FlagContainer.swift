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

#if canImport(VexilMacros)

import SwiftSyntax
import SwiftSyntaxMacroExpansion
import VexilMacros

extension MacroSpec {

    /// The spec for `@FlagContainer`.
    ///
    /// The conformances here mirror the `conformances:` list on the `@attached(extension, ...)` declaration of
    /// `@FlagContainer` in `Sources/Vexil/Container.swift`. `assertMacroExpansion` only ever sees a
    /// name-to-implementation mapping, so it has to be told that list separately.
    ///
    /// Note this models the case where the annotated type declares none of the conformances itself: a real
    /// build passes only the conformances the type does not already satisfy, whereas `MacroSpec` passes the
    /// list through verbatim. Expansions of a type that already declares one of them therefore can't be
    /// reproduced here by varying the source alone — it takes a spec with a narrower list.
    static let flagContainer = MacroSpec(
        type: FlagContainerMacro.self,
        conformances: [
            TypeSyntax(IdentifierTypeSyntax(name: .identifier("FlagContainer"))),
            TypeSyntax(IdentifierTypeSyntax(name: .identifier("Equatable"))),
            TypeSyntax(IdentifierTypeSyntax(name: .identifier("Sendable"))),
        ],
    )

    /// The spec for `@Flag`, which is an accessor and peer macro and so adds no conformances.
    static let flag = MacroSpec(type: FlagMacro.self)

}

#endif
