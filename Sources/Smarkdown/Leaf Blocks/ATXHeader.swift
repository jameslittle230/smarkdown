//
//  ATXHeader.swift
//  Smarkdown
//
//  Created by James Little on 6/1/19.
//

import Foundation

struct ATXHeader: LeafBlock {
    enum Level: Int {
        case one = 1
        case two
        case three
        case four
        case five
        case six
    }

    let level: ATXHeader.Level
    let contents: String?

    func render(_ str: String) -> String {
        let levelNumber = level.rawValue
        return "<h\(levelNumber)>\(contents ?? "")</h\(levelNumber)>"
    }

    static func consume(_ str: String) -> ATXHeader? {
        enum ParseState {
            case initialHashes
            case internalContent
            case trailingHashes
        }

        guard !str.starts(with: "    ") else {
            return nil
        }

        let candidate = str.trim()
        var output = ""

        guard candidate.count > 0 else {
            return nil
        }

        var hashOffsetCount = 0
        var state = ParseState.initialHashes
        var maybeItsTheEnd = ""
        for character in candidate {
            switch state {
            case .initialHashes:
                if character == "#" { hashOffsetCount += 1 }
                if hashOffsetCount > 6 { return nil }

                if character != "#" {
                    state = .internalContent
                    fallthrough
                }

            case .internalContent:
                if character == "#" {
                    state = .trailingHashes
                    fallthrough
                }

                output.append(character)

            case .trailingHashes:
                maybeItsTheEnd.append(character)
                if character != "#" {
                    output.append(maybeItsTheEnd)
                    maybeItsTheEnd = ""
                    state = .internalContent
                }
            }
        }

        guard output.starts(with: " ") || output == "" else {
            return nil
        }

        output = output.trim()

        guard let level = ATXHeader.Level(rawValue: hashOffsetCount) else {
            return nil
        }

        return ATXHeader(level: level, contents: output)
    }
}
