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

extension String {
    var localizedDisplayName: String {
        return displayName(with: Locale.autoupdatingCurrent)
    }

    var displayName: String {
        return self.displayName(with: nil)
    }

    func displayName(with locale: Locale?) -> String {
        let uppercased = CharacterSet.uppercaseLetters
        return (hasPrefix("_") ? String(dropFirst()) : self)
            .separatedAtWordBoundaries
            .map { CharacterSet(charactersIn: $0).isStrictSubset(of: uppercased) ? $0 : $0.capitalized(with: locale) }
            .joined(separator: " ")
    }

    /// Separates a string at word boundaries, eg. `oneTwoThree` becomes `one Two Three`
    ///
    /// Capital characters are determined by testing membership in `CharacterSet.uppercaseLetters`
    /// and `CharacterSet.lowercaseLetters` (Unicode General Categories Lu and Lt).
    /// The conversion to lower case uses `Locale.system`, also known as the ICU "root" locale. This means
    /// the result is consistent regardless of the current user's locale and language preferences.
    ///
    /// Adapted from JSONEncoder's `toSnakeCase()`
    ///
    var separatedAtWordBoundaries: [String] {
        guard !isEmpty else {
            return []
        }

        let string = self

        var words: [Range<String.Index>] = []
        // The general idea of this algorithm is to split words on transition from lower to upper case, then on
        // transition of >1 upper case characters to lowercase
        //
        // myProperty -> my_property
        // myURLProperty -> my_url_property
        //
        // We assume, per Swift naming conventions, that the first character of the key is lowercase.
        var wordStart = string.startIndex
        var searchRange = string.index(after: wordStart) ..< string.endIndex

        let uppercase = CharacterSet.uppercaseLetters.union(CharacterSet.decimalDigits)

        // Find next uppercase character
        while let upperCaseRange = string.rangeOfCharacter(from: uppercase, options: [], range: searchRange) {
            let untilUpperCase = wordStart ..< upperCaseRange.lowerBound
            words.append(untilUpperCase)

            // Find next lowercase character
            searchRange = upperCaseRange.lowerBound ..< searchRange.upperBound
            guard let lowerCaseRange = string.rangeOfCharacter(from: CharacterSet.lowercaseLetters, options: [], range: searchRange) else {
                // There are no more lower case letters. Just end here.
                wordStart = searchRange.lowerBound
                break
            }

            // Is the next lowercase letter more than 1 after the uppercase? If so, we encountered a group of uppercase
            // letters that we should treat as its own word
            let nextCharacterAfterCapital = string.index(after: upperCaseRange.lowerBound)
            if lowerCaseRange.lowerBound == nextCharacterAfterCapital {
                // The next character after capital is a lower case character and therefore not a word boundary.
                // Continue searching for the next upper case for the boundary.
                wordStart = upperCaseRange.lowerBound
            } else {
                // There was a range of >1 capital letters. Turn those into a word, stopping at the capital before the lower case character.
                let beforeLowerIndex = string.index(before: lowerCaseRange.lowerBound)
                words.append(upperCaseRange.lowerBound ..< beforeLowerIndex)

                // Next word starts at the capital before the lowercase we just found
                wordStart = beforeLowerIndex
            }
            searchRange = lowerCaseRange.upperBound ..< searchRange.upperBound
        }
        words.append(wordStart ..< searchRange.upperBound)

        return words.map { string[$0].lowercased() }
    }
}

#endif
