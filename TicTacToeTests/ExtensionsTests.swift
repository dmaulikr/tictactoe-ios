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
    
    func testBoardPointMakeFromIndexPath() {
        let indexPaths0 = IndexPath(item: 0, section: 0)
        let indexPaths1 = IndexPath(item: 1, section: 0)
        let indexPaths2 = IndexPath(item: 2, section: 0)
        let indexPaths3 = IndexPath(item: 3, section: 0)
        let indexPaths4 = IndexPath(item: 4, section: 0)
        let indexPaths5 = IndexPath(item: 5, section: 0)
        let indexPaths6 = IndexPath(item: 6, section: 0)
        let indexPaths7 = IndexPath(item: 7, section: 0)
        let indexPaths8 = IndexPath(item: 8, section: 0)
        
        let board0 = BoardPoint.make(from: indexPaths0)
        XCTAssertTrue(board0.column == 0 && board0.row == 0, "Board is comlum:\(board0.column); row: \(board0.row)")
        
        let board1 = BoardPoint.make(from: indexPaths1)
        XCTAssertTrue(board1.column == 1 && board1.row == 0, "Board is comlum:\(board1.column); row: \(board1.row)")

        let board2 = BoardPoint.make(from: indexPaths2)
        XCTAssertTrue(board2.column == 0 && board2.row == 0, "Board is comlum:\(board2.column); row: \(board2.row)")

        let board3 = BoardPoint.make(from: indexPaths3)
        XCTAssertTrue(board3.column == 0 && board3.row == 0, "Board is comlum:\(board3.column); row: \(board3.row)")

        let board4 = BoardPoint.make(from: indexPaths4)
        XCTAssertTrue(board4.column == 0 && board4.row == 0, "Board is comlum:\(board4.column); row: \(board4.row)")

        let board5 = BoardPoint.make(from: indexPaths5)
        XCTAssertTrue(board5.column == 0 && board5.row == 0, "Board is comlum:\(board5.column); row: \(board5.row)")

        let board6 = BoardPoint.make(from: indexPaths6)
        XCTAssertTrue(board6.column == 0 && board6.row == 0, "Board is comlum:\(board6.column); row: \(board6.row)")

        let board7 = BoardPoint.make(from: indexPaths7)
        XCTAssertTrue(board7.column == 0 && board7.row == 0, "Board is comlum:\(board7.column); row: \(board7.row)")

        let board8 = BoardPoint.make(from: indexPaths8)
        XCTAssertTrue(board8.column == 0 && board8.row == 0, "Board is comlum:\(board8.column); row: \(board8.row)")

    }
    
}
