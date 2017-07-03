//
//  GameManagerTests.swift
//  TicTacToe
//
//  Created by Romilson Nunes on 03/07/17.
//  Copyright © 2017 Romilson Nunes. All rights reserved.
//

import XCTest
@testable import TicTacToe


class GameManagerTests: XCTestCase {
    
    var manager: GameManager = GameManager()
    
    let player1 = Player(identifier: "X", image: #imageLiteral(resourceName: "x"))
    let player2 = Player(identifier: "O", image: #imageLiteral(resourceName: "o"))

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGameReset() {
        let point = BoardPoint(column: 0, row: 0)
        manager.select(point: point, from: player1)
        
        let previousBoard = manager.board
        
        XCTAssertNotNil(manager.lastPlayer)
        
        manager.reset()
        
        XCTAssertFalse("\(previousBoard)" == "\(manager.board)") //Memory address compare
        XCTAssertNil(manager.lastPlayer)
    }
    
}
