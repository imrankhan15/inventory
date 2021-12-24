//
//  Inventor_YTests.swift
//  Inventor-YTests
//
//  Created by Muhammad Faisal Imran Khan on 2/17/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import XCTest
@testable import Inventor_Y

class Inventor_YTests: XCTestCase {
    
    func testSquareInt(){
        let value = 3
        let squaredValue = value.square()
        
        XCTAssertEqual(squaredValue, 9)
    }
    func testHelloWorld(){
        var helloWorld: String?
        
        XCTAssertNil(helloWorld)
        
        helloWorld = "hello world"
        XCTAssertEqual(helloWorld, "hello world")
    }
    
    
    
}
