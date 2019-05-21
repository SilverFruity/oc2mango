//
//  JudgementExpressionTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/19.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class JudgementExpressionTest: XCTestCase {
    let ocparser = Parser.shared()
    var source = ""
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        ocparser.clear()
    }

    func testNormalJudgement(){
        source =
"""
        x++;
        x < 1;
        x < 1 && b > 0;
"""
        ocparser.parseSource(source);
        XCTAssert(ocparser.isSuccess())
        let assign = ocparser.ast.globalStatements[0] as? DeclareAssignExpression;
    }

}
