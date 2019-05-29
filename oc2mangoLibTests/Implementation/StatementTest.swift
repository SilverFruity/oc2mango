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
    
}else if (x){
    
}else if ( y == 0 ){
    
}else{
    
}
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let state = ocparser.ast.globalStatements.firstObject as! IfStatement
        XCTAssert(state.condition == nil)
        XCTAssert(state.funcImp != nil)
        
        let elseif2 = state.last;
        XCTAssert(elseif2?.condition != nil)
        XCTAssert(elseif2?.funcImp != nil)
        
        let elseif1 = elseif2?.last;
        XCTAssert(elseif1?.condition != nil)
        XCTAssert(elseif1?.funcImp != nil)
        
        let ifS = elseif1?.last;
        XCTAssert(ifS?.condition != nil)
        XCTAssert(ifS?.funcImp != nil)
        XCTAssert(ifS?.funcImp.isKind(of: BlockImp.classForCoder()) ?? false)
        
        
        // if ()
        let condition = ifS?.condition as? BinaryExpression
        XCTAssert(condition?.operatorType == BinaryOperatorGE)
        let left1 = condition?.left as? OCValue
        let right1 = condition?.right as? OCValue
        XCTAssert(left1?.value_type == OCValueVariable && left1?.value as! String == "x")
        XCTAssert(right1?.value_type == OCValueInt && right1?.value as! String == "0")
        
        let condition1 = elseif1?.condition as? OCValue
        XCTAssert(condition1?.value as! String == "x")
        
        let condition2 = elseif2?.condition as? BinaryExpression
        XCTAssert(condition2?.operatorType == BinaryOperatorEqual)

        
    }
    func testDoWhileStatement(){
        let source =
"""
do{
        
}while(x > 0 && x < 0)
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let state = ocparser.ast.globalStatements.firstObject as! DoWhileStatement
        XCTAssert(state.funcImp != nil)
        XCTAssert(state.condition != nil)
    }
    func testWhileStatement(){
        let source =
"""
while(x > 0 && x < 0){

}
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let state = ocparser.ast.globalStatements.firstObject as! WhileStatement
        XCTAssert(state.funcImp != nil)
        XCTAssert(state.condition != nil)
        
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
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess());
        let state1 = ocparser.ast.globalStatements.firstObject as! SwitchStatement
        XCTAssert(state1.value != nil)
        XCTAssert(state1.cases.count == 3)
        
        let state2 = ocparser.ast.globalStatements[1] as! SwitchStatement
        XCTAssert(state2.value != nil)
        XCTAssert(state2.cases.count == 3)
        
    }
    func testForStatement(){
        let source =
"""
for (int x = 0; x < 1; x++) {
}
for (int x = 0, b = 0; x < 1 && b < 20; x++, b++) {
    
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
