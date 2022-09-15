//
//  StatementTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class StatementTest: XCTestCase {
    let parser = Parser()
    override func setUp() {
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    func testIfStatement(){
        let source =
"""
if (x >= 0 ){
    
}else if (x){
    
}else if ( y == 0 ){
    
}else{
    
}
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let state = ast.globalStatements.firstObject as! ORIfStatement
        XCTAssert(state.condition == nil)
        XCTAssert(state.scopeImp != nil)
        
        let elseif2 = state.last;
        XCTAssert(elseif2?.condition != nil)
        XCTAssert(elseif2?.scopeImp != nil)
        
        let elseif1 = elseif2?.last;
        XCTAssert(elseif1?.condition != nil)
        XCTAssert(elseif1?.scopeImp != nil)
        
        let ifS = elseif1?.last;
        XCTAssert(ifS?.condition != nil)
        XCTAssert(ifS?.scopeImp != nil)
        
        
        // if ()
        let condition = ifS?.condition as? ORBinaryExpression
        XCTAssert(condition?.operatorType == BinaryOperatorGE)
        let left1 = condition?.left as? ORValueExpression
        let right1 = condition?.right as? ORIntegerValue
        XCTAssert(left1?.value_type == OCValueVariable && left1?.value as! String == "x")
        XCTAssert(right1?.value == 0)
        
        let condition1 = elseif1?.condition as? ORValueExpression
        XCTAssert(condition1?.value as! String == "x")
        
        let condition2 = elseif2?.condition as? ORBinaryExpression
        XCTAssert(condition2?.operatorType == BinaryOperatorEqual)

        
    }
    func testDoWhileStatement(){
        let source =
"""

do{
        
}while(x > 0 && x < 0)

"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let state = ast.globalStatements.firstObject as! ORDoWhileStatement
        XCTAssert(state.scopeImp != nil)
        XCTAssert(state.condition != nil)
    }
    func testWhileStatement(){
        let source =
"""
while(x > 0 && x < 0){

}
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let state = ast.globalStatements.firstObject as! ORWhileStatement
        XCTAssert(state.scopeImp != nil)
        XCTAssert(state.condition != nil)
        
    }
    func testSwitchStatement(){
        let source =
"""
switch (x) {
    case -1: { }
    case 'A': { }
    default:
    {
        NSString *name;
        break;
    }
}
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
switch (x) {
    case 1:
        NSString *name;
        break;

    case 2:
        NSString *name;
        break;
        
    default:
        NSString *name;
        break;
}
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess());
        let state1 = ast.globalStatements.firstObject as! ORSwitchStatement
        XCTAssert(state1.value != nil)
        XCTAssert(state1.cases.count == 3)
        
        let state2 = ast.globalStatements[1] as! ORSwitchStatement
        XCTAssert(state2.value != nil)
        XCTAssert(state2.cases.count == 3)
        
    }
    func testForStatement(){
        let source =
"""
int i;
for (i = 0; i < 1; i++) {
}

for (int x = 0; x < 1; x++) {
}

for (int x = 0, b = 0; x < 1 && b < 20; x++, b++) {
 

}
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess());
        
    }
    
    func testForInStatement(){
        let source =
"""

for (__kindof UIView *view in self.view.subviews) {
    
}

"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess());
        
    }
}
