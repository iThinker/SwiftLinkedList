//
//  LinkedListPerformanceTests.swift
//  LinkedListPerformanceTests
//
//  Created by Roman Temchenko on 2023-07-15.
//

import XCTest
import LinkedList

final class LinkedListPerformanceTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testAppendPerformance() throws {
        func measure(_ block: () -> ()) -> Double {
            let start = CACurrentMediaTime()
            block()
            let end = CACurrentMediaTime()
            
            return end - start
        }

        let measureList = LinkedList<Int>()
        let listResult = measure {
            for i in 0..<10000 {
                measureList.append(i)
            }
        }

        var listSum = 0
        let listSumResult = measure {
            for i in measureList {
                listSum += i
            }
        }
        print("List \(listResult) \(listSum) \(listSumResult)")


        var measureArray = Array<Int>()
        let arrayResult = measure {
            for i in 0..<10000 {
                measureArray.append(i)
            }
        }

        var arraySum = 0
        let arraySumResult = measure {
            for i in measureArray {
                arraySum += i
            }
        }

        print("Array \(arrayResult) \(arraySum) \(arraySumResult)")
    }

    func testPrependPerformance() throws {
        func measure(_ block: () -> ()) -> Double {
            let start = CACurrentMediaTime()
            block()
            let end = CACurrentMediaTime()
            
            return end - start
        }

        let measureList = LinkedList<Int>()
        let listResult = measure {
            for i in 0..<10000 {
                measureList.prepend(i)
            }
        }

        var listSum = 0
        let listSumResult = measure {
            for i in measureList {
                listSum += i
            }
        }
        print("List \(listResult) \(listSum) \(listSumResult)")


        var measureArray = Array<Int>()
        let arrayResult = measure {
            for i in 0..<10000 {
                measureArray.insert(i, at: 0)
            }
        }

        var arraySum = 0
        let arraySumResult = measure {
            for i in measureArray {
                arraySum += i
            }
        }

        print("Array \(arrayResult) \(arraySum) \(arraySumResult)")
    }


}
