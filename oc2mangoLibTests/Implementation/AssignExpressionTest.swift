//
//  AssignExpressionTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/12.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class AssignExpressionTest: XCTestCase {
    let ocparser = Parser.shared()
    var source = ""
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        ocparser.clear()
    }

    
    func testExample() {
        source =
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
        
    }
}
