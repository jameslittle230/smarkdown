//
//  ThematicBreak.swift
//  Smarkdown
//
//  Created by James Little on 6/1/19.
//

import Foundation

struct ThematicBreak: LeafBlock {

    let contents: String? = nil

    func render(_ str: String) -> String {
        return "<hr>"
    }

    static func consume(_ str: String) -> ThematicBreak? {
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
