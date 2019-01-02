//
//  Smarkdown.swift
//  Smarkdown
//
//  Created by James Little on 12/28/18.
//

import Foundation

struct Smarkdown {
    internal func parse(_ markdown: String) -> [Token] {
        let markdown = markdown.normalize()

        var queue = Queue<String>()
        var output: [Token] = []
        
        markdown
            .split(separator: "\n", omittingEmptySubsequences: false)
            .forEach {
                queue.enqueue(String($0))
        }

        while !queue.isEmpty {

            var token = Token()
            while !token.isCompleted && !queue.isEmpty {
                token.consume(queue.dequeue()!)
            }

            output.append(token)
        }

        print(output)
        return output
    }

    internal func render(_ tokens: [Token]) -> String {
        return tokens.reduce("") { accumulator, currentValue in
            return accumulator + currentValue.contents
        }
    }

    func renderAsHTML(markdown: String) -> String {
        let tokens: [Token] = self.parse(markdown)
        let output = self.render(tokens)
        return output
    }
}
