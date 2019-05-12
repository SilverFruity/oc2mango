//
//  AssignExpressionTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/12.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class AssignExpressionTest: XCTestCase {
    let ocparser = Parser.shared()!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let source =
"""
@implementation Demo
- (Demo *)objectMethods{
    int x = 0;
    int x = [NSObject new];
    x -= 1;
    x -= ([self value] == 1);
}
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.classImps.count > 0);
        print(ocparser.expressions());
        ocparser.clear()
    }
}
