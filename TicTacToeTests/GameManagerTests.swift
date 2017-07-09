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
    
    func testGameVictory() {
        // Row
        let point0 = BoardPoint(column: 0, row: 0)
        let point1 = BoardPoint(column: 1, row: 0)
        let point2 = BoardPoint(column: 2, row: 0)

        manager.select(point: point0, from: player1)
        manager.select(point: point1, from: player1)
        manager.select(point: point2, from: player1)

        XCTAssertFalse(manager.checkVictory(from: player2))
        XCTAssertTrue(manager.checkVictory(from: player1))
        
        
        // Diagonal - Inverted Player
        manager.reset()
        
        let point3 = BoardPoint(column: 0, row: 0)
        let point4 = BoardPoint(column: 1, row: 1)
        let point5 = BoardPoint(column: 2, row: 2)
        
        manager.select(point: point3, from: player2)
        manager.select(point: point4, from: player2)
        manager.select(point: point5, from: player2)
        
        XCTAssertFalse(manager.checkVictory(from: player1))
        XCTAssertTrue(manager.checkVictory(from: player2))
        
    }
    
}
