//
//  Token.swift
//  Smarkdown
//
//  Created by James Little on 12/28/18.
//

import Foundation

struct Token {
    var lines: [String] = []
    var block: LeafBlock?
    var isCompleted = false

    var contents: String {
        return lines.joined(separator: "\n")
    }

    mutating func consume(_ input: String) {
        lines.append(input)
        self.test()
    }

    mutating func test() {
        for type in Token.blockTypes {
            if let block = type.consume(contents) {
                self.block = block
                self.isCompleted = true
                return
            }
        }
    }

    func render() throws -> String {
        guard let block = block,
            isCompleted == true,
            !lines.isEmpty else {
                throw TokenError.renderCalledTooEarly
        }

        return block.render(contents)
    }
}

extension Token {
    static let blockTypes: [LeafBlock.Type] = [
        ThematicBreak.self,
        ATXHeader.self,
        SetextHeader.self,
        CodeBlock.self
    ]
}

extension Token: CustomStringConvertible {
    public var description: String {
        return
            "Token(\"" +
            contents.replacingOccurrences(of: "\n", with: "\\n") +
            ")"
    }
}

enum TokenError: Error {
    case renderCalledTooEarly
}
