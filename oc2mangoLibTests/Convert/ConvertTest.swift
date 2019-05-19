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
        ocparser.clear()
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
    }
    
    func testAssignExpressoin(){
        let source =
"""
int x = 0;
"""
        ocparser.parseSource(source)
        let result = convert.convert(ocparser.ast.globalStatements.firstObject as Any)
        XCTAssert(ocparser.error == nil)
        XCTAssert(result == "int x = 0",result)
        ocparser.clear()
    }
    
    func testConvertMethodCall(){
        let source =
"""
[NSObject new].x;
x.get;
[self request:request plugin:plugin completion:completion];
self.block(value,[NSObject new].x);
[self request:^(NSString *name, NSURL *URL){
    [NSObject new];
}];
"""
        ocparser.parseSource(source)
        let result1 = convert.convert(ocparser.ast.globalStatements[0] as Any)
        let result2 = convert.convert(ocparser.ast.globalStatements[1] as Any)
        let result3 = convert.convert(ocparser.ast.globalStatements[2] as Any)
        let result4 = convert.convert(ocparser.ast.globalStatements[3] as Any)
        let result5 = convert.convert(ocparser.ast.globalStatements[4] as Any)
        XCTAssert(ocparser.error == nil)
        XCTAssert(result1 == "NSObject.new().x",result1)
        XCTAssert(result2 == "x.get",result2)
        XCTAssert(result3 == "self.request:plugin:completion:(request,plugin,completion)",result3)
        XCTAssert(result4 == "self.block(value,NSObject.new().x)",result4)
        XCTAssert(result5 ==
            """
            self.request:(^void (NSString *name,NSURL *URL){
            NSObject.new();
            })
            ""","\n"+result5)
        
    }

}
