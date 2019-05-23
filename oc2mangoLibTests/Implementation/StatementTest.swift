//
//  StatementTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class StatementTest: XCTestCase {
    let ocparser = Parser.shared()
    override func setUp() {
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ocparser.clear()
    }
    func testIfStatement(){
        let source =
"""
if (x >= 0 ){
    
}else if ( x == 0 ){
    
}else{
    
}
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        
    }
    func testDoWhileStatement(){
        let source =
"""
do{
        
}while((x > 0) && (x < 0))
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        
        
    }
    func testWhileStatement(){
        let source =
"""
while((x > 0) && (x < 0)){

}
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        
        
    }
    func testSwitchStatement(){
        let source =
"""
switch (x) {
    case 1:
    {
        NSString *name;
        break;
    }
    case 2:
    {
        NSString *name;
        break;
    }
        
    default:
    {
        NSString *name;
        break;
    }
}
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess());
        
    }
    func testForStatement(){
        let source =
"""
for (int x = 0; x++; x < 10) {
    
}
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess());
        
    }
    
    func testForInStatement(){
        let source =
"""
for (UIView *view in self.view.subviews) {
    
}
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess());
        
    }
}
