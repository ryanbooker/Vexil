//===----------------------------------------------------------------------===//
//
// This source file is part of the Vexil open source project
//
// Copyright (c) 2023 Unsigned Apps and the open source contributors.
// Licensed under the MIT license
//
// See LICENSE for license information
//
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//

#if os(iOS) || os(macOS) || os(visionOS)

import Foundation
import SwiftUI
import Vexil

@available(OSX 11.0, iOS 13.0, watchOS 7.0, tvOS 13.0, visionOS 1.0, *)
struct UnfurledFlagGroup<Group, Root>: UnfurledFlagItem, Identifiable where Group: FlagContainer, Root: FlagContainer {

    // MARK: - Properties

    let info: UnfurledFlagInfo
    let group: FlagGroup<Group>
    let hasChildren = true

    private let manager: FlagValueManager<Root>

    var id: UUID {
        return group.id
    }

    var isEditable: Bool {
        return allItems()
            .isEmpty == false
    }

    var isLink: Bool {
        return group.display == .navigation
    }

    var childLinks: [UnfurledFlagItem]? {
        let children = allItems().filter { $0.hasChildren == true && $0.isLink }
        return children.isEmpty == false ? children : nil
    }

    // MARK: - Initialisation

    init(name: String, group: FlagGroup<Group>, manager: FlagValueManager<Root>) {
        self.info = UnfurledFlagInfo(key: "", info: group.info, defaultName: name)
        self.group = group
        self.manager = manager
    }


    // MARK: - Unfurled Flag Item Conformance

    func allItems() -> [UnfurledFlagItem] {
        return Mirror(reflecting: group.wrappedValue)
            .children
            .compactMap { child -> UnfurledFlagItem? in
                guard let label = child.label, let unfurlable = child.value as? Unfurlable else {
                    return nil
                }
                guard let unfurled = unfurlable.unfurl(label: label, manager: self.manager) else {
                    return nil
                }
                return unfurled.isEditable ? unfurled : nil
            }
    }

    var unfurledView: AnyView {
        switch group.display {
        case .navigation:
            return unfurledNavigationLink

        case .section:
            return UnfurledFlagSectionView(group: self, manager: manager)
                .eraseToAnyView()
        }
    }

    private var unfurledNavigationLink: AnyView {
        var destination = UnfurledFlagGroupView(group: self, manager: manager).eraseToAnyView()

#if os(iOS)

        destination = destination
            .navigationBarTitle(Text(info.name), displayMode: .inline)
            .eraseToAnyView()

#elseif compiler(>=5.3.1)

        destination = destination
            .navigationTitle(info.name)
            .eraseToAnyView()

#endif

        return NavigationLink(destination: destination) {
            HStack {
                Text(self.info.name)
                    .font(.headline)
            }
        }.eraseToAnyView()
    }

}

#endif
