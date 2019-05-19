//
//  TypeSpecailTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/19.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class AssignExpression: XCTestCase {
    let ocparser = Parser.shared()
    var source = ""
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ocparser.clear()
    }

    func testTypeSpecail(){
        source =
"""
        int a;
        int *a;
"""
        ocparser.parseSource(source)
        let assign = ocparser.ast.globalStatements[0] as? DeclareAssignExpression;
        XCTAssert(assign?.declare.type.type == SpecialTypeInt)
        XCTAssert(assign?.declare.name == "a")
    }

}
