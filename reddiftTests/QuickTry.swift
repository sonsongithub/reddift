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
    override func spec() {
        it("is equal") {
            let value = 2 + 2
            expect(value).to(equal(5))
        }
    }
}
