//
//  QuickTry.swift
//  reddift
//
//  Created by sonson on 2015/05/07.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Quick
import Nimble

class QuickTry: QuickSpec {
    override func setUp() {
        super.setUp()
        println("a")
    }
    
    override func spec() {
        beforeEach {
            println("beforeEach 1")
        }
        
        describe("Test test", { () -> Void in
            beforeEach {
                println("beforeEach 2")
            }
            
            it("is equal") {
                let value = 2 + 3
                expect(value).to(equal(5))
            }
            
            it("is equal2") {
                let value = 3 + 3
                expect(value).to(equal(5))
            }
        })
        
        describe("Test test2", { () -> Void in
            beforeEach {
                println("beforeEach 3")
            }
            
            it("is equal") {
                let value = 2 + 3
                expect(value).to(equal(5))
            }
            
            it("is equal2") {
                let value = 3 + 3
                expect(value).to(equal(5))
            }
        })
    }
}
