

//
//  CalculateExpressionTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/19.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class CalculateExpressionTest: XCTestCase {
    let ocparser = Parser.shared()
    var source = ""
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        ocparser.clear()
    }



}
