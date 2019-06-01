//
//  FencedCodeBlock.swift
//  Smarkdown
//
//  Created by James Little on 6/1/19.
//

import Foundation

struct FencedCodeBlock: LeafBlock {
    var contents: String?
    var infoString: String?

    enum FirstLineState {
        case leadingSpaces
        case fenceCharacters
        case infoString
    }

    struct FencedBlockStats {
        let numberOfLeadingSpaces: Int
        let numberOfFenceCharacters: Int
        let fenceCharacter: String

        var infoStringOffset: Int {
            return numberOfLeadingSpaces + numberOfFenceCharacters
        }
    }

    static func validateFirstLineOfFence(_ firstLine: String) -> FencedBlockStats? {
        var numberOfLeadingSpaces = 0
        var numberOfFenceCharacters = 0
        var fenceCharacter = ""

        var currentFirstLineState = FirstLineState.leadingSpaces

        for char in firstLine {
            switch currentFirstLineState {
            case .leadingSpaces:
                if String(char) != " " {
                    currentFirstLineState = .fenceCharacters
                    fenceCharacter = String(char)
                    numberOfFenceCharacters += 1
                    continue
                }

                numberOfLeadingSpaces += 1

                if numberOfLeadingSpaces > 3 { return nil }
            case .fenceCharacters:
                guard ["`", "~"].contains(fenceCharacter) else { return nil }

                if String(char) != fenceCharacter {
                    currentFirstLineState = .infoString
                    continue
                }

                numberOfFenceCharacters += 1
            case .infoString:
                guard numberOfFenceCharacters >= 3 else { return nil }
                guard String(char) != "`" else { return nil }
            }
        }

        return FencedBlockStats(numberOfLeadingSpaces: numberOfLeadingSpaces,
                                numberOfFenceCharacters: numberOfFenceCharacters,
                                fenceCharacter: fenceCharacter)
    }

    static func consume(_ str: String) -> FencedCodeBlock? {

        let lines = str.components(separatedBy: "\n")

        guard lines.count > 2, let firstLine = lines.first, let lastLine = lines.last else {
            return nil
        }

        guard !firstLine.starts(with: "    "),
            !lastLine.starts(with: "    ") else {
                return nil
        }

        guard let stats = validateFirstLineOfFence(firstLine) else {
            return nil
        }

        let infoString = String(firstLine[
            firstLine.index(firstLine.startIndex, offsetBy: stats.infoStringOffset)...]
            ).trim()

        let trimmedLastLine = lastLine.trim()

        guard trimmedLastLine.count >= stats.numberOfFenceCharacters else {
            return nil
        }

        guard Set(trimmedLastLine.map({String($0)})).count <= 1,
            String(trimmedLastLine[trimmedLastLine.index(after: trimmedLastLine.startIndex)]) == stats.fenceCharacter
            else {
                return nil
        }

        let contents = lines[1..<lines.count - 1].map({
            var candidate = $0
            var count = 0

            while count < stats.numberOfLeadingSpaces && candidate[candidate.startIndex] == " " {
                count += 1
                candidate.removeFirst()
            }

            return candidate
        }).joined(separator: "\n")

        return FencedCodeBlock(contents: contents, infoString: infoString)
    }

    func render(_ str: String) -> String {
        return "<pre><code>"
    }
}
