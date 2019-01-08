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

/* http://www.mczarnik.com/2017/04/08/break-out-of-reduce.html */
enum BreakConditionError<Result>: Error {
    case conditionPassedWithResult(Result)
}

extension Sequence {
    func reduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: (Result, Self.Iterator.Element) throws -> Result,
        while conditionPassFor: (Result, Self.Iterator.Element) -> Bool
        ) rethrows -> Result {

        do {
            return try reduce(
                initialResult, {
                    let nextPartialResult = try nextPartialResult($0, $1)
                    if conditionPassFor(nextPartialResult, $1) {
                        return nextPartialResult
                } else {
                    throw BreakConditionError
                        .conditionPassedWithResult($0)
                }
            })
        } catch BreakConditionError<Result>
            .conditionPassedWithResult(let result) {
                return result
        }
    }
}
