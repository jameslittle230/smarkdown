//
//  HTMLBlock.swift
//  Smarkdown
//
//  Created by James Little on 6/1/19.
//

import Foundation

struct HTMLBlock: LeafBlock {
    var contents: String?

    static func consume(_ str: String) -> HTMLBlock? {
        let lines = str.components(separatedBy: "\n")

        guard let firstLine = lines.first, let lastLine = lines.last else {
            return nil
        }

        guard !firstLine.starts(with: "    ") else {
            return nil
        }

        let trimmedFirst = firstLine.trim()

        // Type 1
        if let _ = trimmedFirst.range(of: "<(pre)|(script)|(style)\\s+>?$", options: .regularExpression),
            let _ = lastLine.range(of: "<\\/(script)|(pre)|(style)>", options: .regularExpression) {
            return HTMLBlock(contents: str)
        }

        // Type 2
        if let _ = trimmedFirst.range(of: "^<!--", options: .regularExpression),
            let _ = lastLine.range(of: "-->", options: .regularExpression) {
            return HTMLBlock(contents: str)
        }

        // Type 3
        if let _ = trimmedFirst.range(of: #"^<\?"#, options: .regularExpression),
            let _ = lastLine.range(of: #"\?>"#, options: .regularExpression) {
            return HTMLBlock(contents: str)
        }

        // Type 4
        if let _ = trimmedFirst.range(of: "^<![A-Z]", options: .regularExpression),
            let _ = lastLine.range(of: ">", options: .regularExpression) {
            return HTMLBlock(contents: str)
        }

        // Type 5
        if let _ = trimmedFirst.range(of: #"^<!\[CDATA\["#, options: .regularExpression),
            let _ = lastLine.range(of: #"\]\]>"#, options: .regularExpression) {
            return HTMLBlock(contents: str)
        }

        // Type 6 & 7 (fudged)
        if trimmedFirst.range(of: #"^<\/?[a-zA-Z]+[a-zA-Z0-9]*\/?>"#, options: .regularExpression) != nil,
            lastLine == "" {
            return HTMLBlock(contents: str)
        }

        return nil
    }

    func render(_ str: String) -> String {
        return "HTML Block"
    }


}
