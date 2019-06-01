//
//  Blocks.swift
//  Smarkdown
//
//  Created by James Little on 12/28/18.
//

import Foundation

protocol LeafBlock {
    var contents: String? { get }
    static func consume(_ str: String) -> Self?
    func render(_ str: String) -> String
}
