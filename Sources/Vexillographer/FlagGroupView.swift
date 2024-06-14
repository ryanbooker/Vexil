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

import SwiftUI
import Vexil

@available(OSX 11.0, iOS 13.0, watchOS 7.0, tvOS 13.0, visionOS 1.0, *)
struct UnfurledFlagGroupView<Group, Root>: View where Group: FlagContainer, Root: FlagContainer {

    // MARK: - Properties

    let group: UnfurledFlagGroup<Group, Root>
    @ObservedObject
    var manager: FlagValueManager<Root>


    // MARK: - Initialisation

    init(group: UnfurledFlagGroup<Group, Root>, manager: FlagValueManager<Root>) {
        self.group = group
        self.manager = manager
    }


    // MARK: - View Body

#if os(iOS)

    var body: some View {
        Form {
            Section {
                self.description
            }
            .padding([.top, .bottom], 4)
            self.flags
        }
    }

#elseif os(macOS) && compiler(>=5.3.1)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                self.description
                    .padding(.bottom, 8)
                Divider()
            }
            .padding()

            Form {
                Section {
                    // Filter out all links. They won't work on the mac flag group view.
                    ForEach(self.group.allItems().filter { $0.isLink == false }, id: \.id) { item in
                        UnfurledFlagItemView(item: item)
                    }
                }
            }
            .padding([.leading, .trailing, .bottom], 30)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationTitle(self.group.info.name)
    }

#else

    var body: some View {
        Form {
            self.description
            Section {
                self.flags
            }
        }
    }

#endif

    var description: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Description").font(.headline)
            Text(self.group.info.description)
        }
        #if !os(visionOS)
        .contextMenu {
            CopyButton(action: self.group.info.description.copyToPasteboard)
        }
        #endif
    }

    var flags: some View {
        ForEach(self.group.allItems(), id: \.id) { item in
            UnfurledFlagItemView(item: item)
        }
    }

}

#endif
