//
//  Extensions.swift
//  Smarkdown
//
//  Created by James Little on 12/28/18.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }

    func normalize() -> String {
        return self.replacingOccurrences(of: "\r\n", with: "\n")
    }
}
