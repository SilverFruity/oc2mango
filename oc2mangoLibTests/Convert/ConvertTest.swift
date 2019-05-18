//
//  ConvertTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class ConvertTest: XCTestCase {
    let ocparser = Parser.shared()
    let convert = Convert()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testTypeSpecail(){
        let source =
"""
int x;
Object *x;
BOOL x;
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let result = convert.convert(ocparser.ast.globalStatements[0] as Any)
        let result1 = convert.convert(ocparser.ast.globalStatements[1] as Any)
        let result2 = convert.convert(ocparser.ast.globalStatements[2] as Any)
        XCTAssert(ocparser.error == nil)
        XCTAssert(result == "int x")
        XCTAssert(result1 == "Object *x")
        XCTAssert(result2 == "BOOL x")
        ocparser.clear()
    }
    
    func testAssignExpressoin(){
        let source =
"""
int x = 0;
"""
        ocparser.parseSource(source)
        let result = convert.convert(ocparser.ast.globalStatements.firstObject as Any)
        XCTAssert(ocparser.error == nil)
        XCTAssert(result == "int x = 0")
        ocparser.clear()
    }

}
