//
//  Blocks.swift
//  Smarkdown
//
//  Created by James Little on 12/28/18.
//

import Foundation

protocol LeafBlock {
    var contents: String? { get }
    static func consume(_ str: String) -> LeafBlock?
    func render(_ str: String) -> String
}

struct ThematicBreak: LeafBlock {
    let contents: String? = nil

    func render(_ str: String) -> String {
        return "<hr>"
    }

    static func consume(_ str: String) -> LeafBlock? {
        guard !str.starts(with: "    ") else {
            return nil
        }

        let contents = str.replacingOccurrences(of: " ", with: "")

        guard
            contents.count >= 3, // At least three elements
            Set(contents.map({String($0)})).count <= 1, // They're all the same
            ["-", "*", "_"].contains(contents[contents.startIndex]) // They're all one of these three things
            else {
                return nil
        }

        return ThematicBreak()
    }
}

struct ATXHeader: LeafBlock {
    enum Level {
        case one
        case two
        case three
        case four
        case five
        case six
    }

    let level: ATXHeader.Level
    let contents: String?

    func render(_ str: String) -> String {
        return ""
    }

    static func consume(_ str: String) -> LeafBlock? {
        guard !str.starts(with: "    ") else {
            return nil
        }

        var contents = str.trim()

        var iterator = contents.startIndex
        var endIterator = contents.endIndex

        guard contents.count > 0 else {
            return nil
        }

        // Up to 6 octothorpes
        while iterator != endIterator
            && contents[iterator] == "#"
            && iterator.encodedOffset < 6 {
                iterator = contents.index(after: iterator)
        }

        while iterator != endIterator
            && contents[contents.index(before: endIterator)] == "#" {
                endIterator = contents.index(before: endIterator)
        }

        contents = String(contents[iterator..<endIterator])

        guard contents.starts(with: " ") || contents == "" else {
            return nil
        }

        contents = contents.trim()

        return ATXHeader(level: ATXHeader.Level.one, contents: contents)
    }
}

struct SetextHeader: LeafBlock {
    enum Level {
        case one
        case two
    }

    let contents: String?

    func render(_ str: String) -> String {
        return ""
    }

    static func consume(_ str: String) -> LeafBlock? {
        let lines = str.components(separatedBy: "\n")

        guard var lastLine = lines.last else {
            return nil
        }

        for line in lines {
            if line.starts(with: "    ") {
                return nil
            }
        }

        lastLine = lastLine.trim()

        guard
            lastLine.count > 0,
            Set(lastLine.map({String($0)})).count <= 1, // They're all the same
            ["-", "="].contains(lastLine[lastLine.startIndex]) // They're all one of these three things
            else {
                return nil
        }

        return SetextHeader(contents: lines[0..<lines.count - 1].joined(separator: "\n").trim())
    }
}

struct CodeBlock: LeafBlock {
    var contents: String?

    static func consume(_ str: String) -> LeafBlock? {
        let lines = str.components(separatedBy: "\n")

        for line in lines {
            if !line.starts(with: "    ") && !line.trim().isEmpty {
                return nil
            }
        }

        let contents = lines.map { line in
            if line.starts(with: "    ") {
                return String(line[line.index(line.startIndex, offsetBy: 4) ..< line.endIndex])
            } else {
                return ""
            }
        }.joined(separator: "\n")

        return CodeBlock(contents: contents)
    }

    func render(_ str: String) -> String {
        return "<pre><code>\(contents ?? "")</code></pre>"
    }
}

struct FencedCodeBlock: LeafBlock {
    var contents: String?
    var infoString: String?

    static func consume(_ str: String) -> LeafBlock? {
        let lines = str.components(separatedBy: "\n")

        guard lines.count > 2, let firstLine = lines.first, let lastLine = lines.last else {
            return nil
        }

        guard firstLine.starts(with: "    ") else {
            return nil
        }
    }

    func render(_ str: String) -> String {
        return "<pre><code>"
    }


}
