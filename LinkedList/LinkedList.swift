//
//  LinkedList.swift
//  LinkedList
//
//  Created by Roman Temchenko on 2023-07-14.
//

import Foundation

public final class LinkedList<Element>: Collection {

    public typealias Index = Int
    public typealias Iterator = IteratorImpl
    
    public final class IteratorImpl: IteratorProtocol {
        private var cursor: Node?
        
        fileprivate init(cursor: Node? = nil) {
            self.cursor = cursor
        }
        
        public func next() -> Element? {
            defer {
                cursor = cursor?.next
            }
            return cursor?.value
        }
        
    }
    
    public final class Node {
        fileprivate(set) var value: Element
        internal fileprivate(set) var next: Node?
        internal fileprivate(set) weak var prev: Node?
        
        fileprivate init(value: Element, next: Node? = nil, prev: Node? = nil) {
            self.value = value
            self.next = next
            self.prev = prev
        }
    }
    
    internal var _count = 0 {
        didSet {
            if _count == 0 {
                start = nil
                end = nil
            }
        }
    }
    internal var start: Node?
    internal var end: Node?
    
    // Mark: Public
    
    public init() {}
    
    public init<S>(_ elements: S) where S : Sequence, Element == S.Element {
        elements.forEach { append($0) }
    }
    
    public var values: [Element] {
        Array(self)
    }
    
    @discardableResult
    public func append(_ newElement: Element) -> Node {
        let newNode = Node(value: newElement)
        newNode.prev = end
        end?.next = newNode
        
        if start == nil {
            start = newNode
        }
        end = newNode
        _count += 1
        
        return newNode
    }
    
    @discardableResult
    public func prepend(_ newElement: Element) -> Node {
        let newNode = Node(value: newElement)
        newNode.next = start
        start?.prev = newNode
        
        start = newNode
        if end == nil {
            end = newNode
        }
        _count += 1
        
        return newNode
    }
    
    public var last: Element? {
        end?.value
    }
    
    public func moveToFront(_ node: Node) {
        guard node !== start else { return }
        
        node.prev?.next = node.next
        node.next?.prev = node.prev
        
        if node === end {
            end = node.prev
        }
        
        node.next = start
        node.prev = nil
        start?.prev = node
        start = node
    }
    
    public func sendToBack(_ node: Node) {
        guard node !== end else { return }
        
        node.prev?.next = node.next
        node.next?.prev = node.prev
        
        if node === start {
            start = node.next
        }
        
        node.prev = end
        node.next = nil
        end?.next = node
        end = node
    }
    
    public func remove(_ node: Node) {
        node.prev?.next = node.next
        node.next?.prev = node.prev
        
        if node === start {
            start = node.next
        }
        
        if node === end {
            end = node.prev
        }
        
        _count -= 1
    }
    
    // Mark: Collection
    
    public var count: Int { _count }
    public var startIndex: Int { 0 }
    public var endIndex: Int { _count }
    
    public func makeIterator() -> IteratorImpl {
        IteratorImpl(cursor: start)
    }
    
    public subscript(position: Int) -> Element {
        get {
            precondition(position < _count)
            return node(at: position)!.value
        }
        set {
            precondition(position < _count)
            let node = node(at: position)!
            node.value = newValue
        }
    }
    
    public func index(after i: Int) -> Int {
        i + 1
    }
    
    public var first: Element? {
        start?.value
    }
    
    
    // Mark: Private
    
    private func node(at index: Int) -> Node? {
        if index == startIndex {
            return start
        }
        else if index == endIndex {
            return end
        }
        
        var cursor = start
        for _ in 0..<index {
            cursor = cursor?.next
        }
        
        return cursor
    }
}

extension LinkedList: RangeReplaceableCollection {
    
    public func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, Element == C.Element, Int == R.Bound {
        let subrange = subrange.relative(to: self)
        
        precondition(subrange.lowerBound >= startIndex)
        precondition(subrange.upperBound <= endIndex)
        
        if subrange.startIndex == startIndex {
            subrange.forEach { _ in removeFirst() }
            if newElements.isEmpty == false {
                let tmpList = LinkedList(newElements)
                tmpList.end?.next = start
                start?.prev = tmpList.end
                start = tmpList.start
                _count += tmpList.count
                
                if end === nil {
                    end = tmpList.end
                }
            }
        }
        else if subrange.endIndex == endIndex {
            subrange.forEach { _ in removeLast() }
            newElements.forEach { append($0) }
        }
        else {
            var node: Node? = node(at: subrange.startIndex)
            subrange.forEach { _ in
                node.map(remove(_:))
                node = node?.next
            }
            
            if newElements.isEmpty == false {
                let tmpList = LinkedList(newElements)
                
                tmpList.start?.prev = node?.prev
                node?.prev?.next = tmpList.start
                
                tmpList.end?.next = node
                node?.prev = tmpList.end
                
                _count += tmpList.count
            }
            
        }
    }
    
    @discardableResult public func removeFirst() -> Element {
        precondition(_count > 0)
        let value = start?.value
        remove(start!)
        
        return value!
    }

    @discardableResult public func removeLast() -> Element {
        precondition(_count > 0)
        let value = end?.value
        remove(end!)
        
        return value!
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        _count = 0
    }
    
}

extension LinkedList: BidirectionalCollection {
    
    public func index(before i: Index) -> Index {
        i - 1
    }
    
}

extension LinkedList: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element
    
    public convenience init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(elements)
    }
}
