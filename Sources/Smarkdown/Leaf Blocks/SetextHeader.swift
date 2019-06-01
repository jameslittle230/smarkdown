//
//  SetextHeader.swift
//  Smarkdown
//
//  Created by James Little on 6/1/19.
//

import Foundation

struct SetextHeader: LeafBlock {
    enum Level {
        case one
        case two
    }

    let contents: String?

    func render(_ str: String) -> String {
        return ""
    }

    static func consume(_ str: String) -> SetextHeader? {
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
            ["-", "="].contains(lastLine[0]) // They're all one of these things
            else {
                return nil
        }

        return SetextHeader(contents: lines[0..<lines.count - 1].joined(separator: "\n").trim())
    }
}
