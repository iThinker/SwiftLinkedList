//
//  LinkedListTests.swift
//  LinkedListTests
//
//  Created by Roman Temchenko on 2023-07-14.
//

import XCTest
@testable import LinkedList

class LinkedListTests: XCTestCase {

    let array = [1, 2, 3]
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testInitWithArray() {
        let sut = LinkedList(array)
        
        XCTAssertEqual(sut.count, array.count)
        XCTAssertEqual(sut.first, array.first)
        XCTAssertEqual(sut.last, array.last)
    }
    
    func testValues() {
        let sut = LinkedList(array)
        let values = sut.values
        
        XCTAssertEqual(array, values)
    }
    
    func testDeinit() {
        var sut: LinkedList? = LinkedList<Int>()
        weak var node1 = sut?.append(1)
        weak var node2 = sut?.append(2)
        
        sut = nil
        
        XCTAssertNil(node1)
        XCTAssertNil(node2)
    }
    
    func testFirst() {
        let sut = LinkedList<Int>()
        XCTAssertNil(sut.first)
        
        sut.append(1)
        
        XCTAssertEqual(sut.first, 1)
    }
    
    func testLast() {
        let sut = LinkedList<Int>()
        XCTAssertNil(sut.last)
        
        sut.append(1)
        
        XCTAssertEqual(sut.last, 1)
    }
    
    func testAppendEmpty() {
        let sut = LinkedList<Int>()
        
        sut.append(1337)
        
        validate(sut, [1337])
    }
    
    func testAppendNotEmpty() {
        let sut = LinkedList(array)
        var expectedArray = array
        expectedArray.append(1337)
        
        sut.append(1337)
        
        validate(sut, expectedArray)
    }
    
    func testPrependEmpty() {
        let sut = LinkedList<Int>()
        
        sut.prepend(1337)
        
        validate(sut, [1337])
    }
    
    func testPrependNotEmpty() {
        let sut = LinkedList(array)
        var expectedArray = array
        expectedArray.insert(1337, at: 0)
        
        sut.prepend(1337)
        
        validate(sut, expectedArray)
    }
    
    func testMoveToFront() {
        let sut = LinkedList(array)
        let node = sut.append(1337)
        var expectedArray = array
        expectedArray.insert(1337, at: 0)
        
        sut.moveToFront(node)
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
    }
    
    func testSendToBack() {
        let sut = LinkedList(array)
        let node = sut.prepend(1337)
        
        var expectedArray = array
        expectedArray.append(1337)
        
        sut.sendToBack(node)
        validate(sut, expectedArray)
        validateNoCycles(sut)
    }
    
    func testCount() {
        let sut = LinkedList<Int>()
        XCTAssertEqual(sut.count, 0)
        
        sut.append(1)
        XCTAssertEqual(sut.count, 1)
    }
    
    func testStartIndex() {
        let sut = LinkedList(array)
        XCTAssertEqual(sut.startIndex, array.startIndex)
    }
    
    func testEndIndex() {
        let sut = LinkedList(array)
        XCTAssertEqual(sut.endIndex, array.endIndex)
    }
    
    func testIterator() {
        let sut = LinkedList(array)
        var newArray = [Int]()
        for element in sut {
            newArray.append(element)
        }
        
        XCTAssertEqual(array, newArray)
    }
    
    func testSubscriptGet() {
        let sut = LinkedList(array)
        for entry in array.enumerated() {
            XCTAssertEqual(sut[entry.offset], entry.element)
        }
    }
    
    func testSubscriptSet() {
        let sut = LinkedList(array)
        sut[0] = 1337
        var expectedArray = array
        expectedArray[0] = 1337
        
        validate(sut, expectedArray)
    }
    
    func testRemoveNode() {
        let sut = LinkedList(array)
        let node = sut.start!.next!
        
        sut.remove(node)
        var expectedArray = array
        expectedArray.remove(at: 1)
        validate(sut, expectedArray)
        
        sut.remove(sut.end!)
        expectedArray.remove(at: 1)
        validate(sut, expectedArray)
        
        sut.prepend(1337)
        sut.remove(sut.start!)
        validate(sut, expectedArray)
    }
    
    func testRemoveFirst() {
        var sut = LinkedList(array)
        let value = sut.removeFirst()
        
        var expectedArray = array
        XCTAssertEqual(value, expectedArray.removeFirst())
        validate(sut, expectedArray)
        
        sut = LinkedList([1])
        sut.removeFirst()
        validate(sut, [])
    }
    
    func testRemoveLast() {
        var sut = LinkedList(array)
        let value = sut.removeLast()
        
        var expectedArray = array
        XCTAssertEqual(value, expectedArray.removeLast())
        validate(sut, expectedArray)
        
        sut = LinkedList([1])
        sut.removeLast()
        validate(sut, [])
    }
    
    func testRemoveAll() {
        let sut = LinkedList(array)
        let expectedArray = [Int]()
        
        sut.removeAll()
        validate(sut, expectedArray)
    }
    
    func testReplaceSubrangeBeginning() {
        let sut = LinkedList<Int>()
        var expectedArray = [Int]()
        var range: any RangeExpression<Int> = ..<0
        
        sut.replaceSubrange(range, with: array)
        expectedArray.replaceSubrange(range, with: array)
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
        
        sut.replaceSubrange(range, with: array)
        expectedArray.replaceSubrange(range, with: array)
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
        
        range = 0...0
        sut.replaceSubrange(range, with: [1337])
        expectedArray.replaceSubrange(range, with: [1337])
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
        
        range = 0...0
        sut.replaceSubrange(range, with: [])
        expectedArray.replaceSubrange(range, with: [])
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
    }
    
    func testReplaceSubrangeEnd() {
        let sut = LinkedList<Int>()
        var expectedArray = [Int]()
        var range: any RangeExpression<Int> = sut.count...
        
        sut.replaceSubrange(range, with: array)
        expectedArray.replaceSubrange(range, with: array)
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
        
        range = sut.count...
        sut.replaceSubrange(range, with: array)
        expectedArray.replaceSubrange(range, with: array)
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
        
        range = (sut.count-1)...
        sut.replaceSubrange(range, with: [1337])
        expectedArray.replaceSubrange(range, with: [1337])
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
        
        range = (sut.count-1)...
        sut.replaceSubrange(range, with: [])
        expectedArray.replaceSubrange(range, with: [])
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
    }
    
    func testReplaceSubrangeMiddle() {
        let sut = LinkedList<Int>(array)
        var expectedArray = array
        var range: any RangeExpression<Int> = 1..<1
        
        sut.replaceSubrange(range, with: array)
        expectedArray.replaceSubrange(range, with: array)
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
        
        range = 1..<2
        sut.replaceSubrange(range, with: [1337])
        expectedArray.replaceSubrange(range, with: [1337])
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
        
        sut.replaceSubrange(range, with: [])
        expectedArray.replaceSubrange(range, with: [])
        
        validate(sut, expectedArray)
        validateNoCycles(sut)
    }
    
    func testInitArrayLiteral() {
        let sut: LinkedList = [1, 2, 3]
        let expectedArray = [1, 2, 3]
        
        validate(sut, expectedArray)
    }
    
    // Mark: Validation Helpers
    
    private func validate<T: Equatable>(_ sut: LinkedList<T>, _ expectedArray: [T]) {
        XCTAssertEqual(sut.values, expectedArray)
        XCTAssertEqual(sut.count, expectedArray.count)
        XCTAssertEqual(sut.first, expectedArray.first)
        XCTAssertEqual(sut.last, expectedArray.last)
    }
    
    private func validateNoCycles<T>(_ sut: LinkedList<T>) {
        var slow = sut.start
        var fast = slow?.next
        var cycleFound = false
        while slow != nil, cycleFound == false {
            if slow === fast {
                cycleFound = true
            }
            
            slow = slow?.next
            fast = fast?.next?.next
        }
        
        XCTAssertFalse(cycleFound, "Found forward cycle")
        
        slow = sut.end
        fast = slow?.prev
        cycleFound = false
        while slow != nil, cycleFound == false {
            if slow === fast {
                cycleFound = true
            }
            
            slow = slow?.prev
            fast = fast?.prev?.prev
        }
        
        XCTAssertFalse(cycleFound, "Found reverse cycle")
    }
    
}
