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

extension StringProtocol {
    subscript(offset: Int) -> Element {
        return self[index(startIndex, offsetBy: offset)]
    }
    subscript(_ range: Range<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        return prefix(range.upperBound.advanced(by: 1))
    }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        return prefix(range.upperBound)
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        return suffix(Swift.max(0, count - range.lowerBound))
    }
}

extension LosslessStringConvertible {
    var string: String { return .init(self) }
}

extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}


