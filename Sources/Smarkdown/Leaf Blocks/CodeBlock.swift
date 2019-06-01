//
//  CodeBlock.swift
//  Smarkdown
//
//  Created by James Little on 6/1/19.
//

import Foundation

struct CodeBlock: LeafBlock {
    var contents: String?

    static func consume(_ str: String) -> CodeBlock? {
        let lines = str.components(separatedBy: "\n")

        for line in lines {
            if !line.starts(with: "    ") && !line.trim().isEmpty {
                return nil
            }
        }

        let contents = lines.map { line in
            if line.starts(with: "    ") {
                return line[4...].string
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
