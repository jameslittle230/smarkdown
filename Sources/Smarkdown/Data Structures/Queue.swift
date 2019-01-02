//
//  Queue.swift
//  Smarkdown
//
//  Created by James Little on 1/1/19.
//

import Foundation

public struct Queue<T> {
    fileprivate var list = LinkedList<T>()

    public mutating func enqueue(_ element: T) {
        list.append(element)
    }

    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        return list.remove(node: element)
    }

    public func peek() -> T? {
        return list.first?.value
    }

    public var isEmpty: Bool {
        return list.isEmpty
    }
}

extension Queue: CustomStringConvertible {
    public var description: String {
        return list.description
    }
}
