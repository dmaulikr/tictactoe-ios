//
//  ExtensionsTests.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 03/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import XCTest
@testable import TicTacToe


class ExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testIndexPathMakeFromBoardPoint() {
        let points = [BoardPoint(column: 0, row: 0),
                      BoardPoint(column: 1, row: 0),
                      BoardPoint(column: 2, row: 0),
                      BoardPoint(column: 0, row: 1),
                      BoardPoint(column: 1, row: 1),
                      BoardPoint(column: 2, row: 1),
                      BoardPoint(column: 0, row: 2),
                      BoardPoint(column: 1, row: 2),
                      BoardPoint(column: 2, row: 2)
        ]
        
        for (index, point) in points.enumerated() {
            let indexPath = IndexPath.make(from: point)
            
            XCTAssertTrue(indexPath.item == index, "Value is \(index)")
        }
    }
    
//    func testBoardPointMakeFromIndexPath() {
//        let indexPaths0 = IndexPath(item: 0, section: 0)
//        let indexPaths1 = IndexPath(item: 1, section: 0)
//        let indexPaths2 = IndexPath(item: 2, section: 0)
//        let indexPaths3 = IndexPath(item: 3, section: 0)
//        let indexPaths4 = IndexPath(item: 4, section: 0)
//        let indexPaths5 = IndexPath(item: 5, section: 0)
//        let indexPaths6 = IndexPath(item: 6, section: 0)
//        let indexPaths7 = IndexPath(item: 7, section: 0)
//        let indexPaths8 = IndexPath(item: 8, section: 0)
//        
//        for (index, indexPath) in IndexPath.enumerated() {
//            let point = BoardPoint.make(from: point)
//            
//            XCTAssertTrue(indexPath.item == index, "Value is \(index)")
//        }
//    }
    
}
