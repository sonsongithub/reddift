//
//  ReddiftColorTest.swift
//  reddift
//
//  Created by sonson on 2017/01/05.
//  Copyright © 2017年 sonson. All rights reserved.
//

import XCTest

class ReddiftColorTest: XCTestCase {
    
    func testReddiftColor() {
        let hexString = "#FFFF00"
        let color = ReddiftColor.color(with: hexString)
        XCTAssert(color.hexString() == hexString)
    }
    
    func testReddiftClassMethodColor() {
        XCTAssert(ReddiftColor.red.hexString() ==   "#FF0000")
        XCTAssert(ReddiftColor.green.hexString() == "#00FF00")
        XCTAssert(ReddiftColor.blue.hexString() ==  "#0000FF")
        XCTAssert(ReddiftColor.yellow.hexString() == "#FFFF00")
    }
}
