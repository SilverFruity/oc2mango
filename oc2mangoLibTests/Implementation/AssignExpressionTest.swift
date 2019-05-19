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
    func testDeclareAssignExpression(){
        source =
        """
        int a;
        int *a;
        unsigned int a;
        char a;
        unsigned char a;
        long a;
        unsigned long a;
        long long a;
        unsigned long long a;
        NSInteger a;
        NSUInteger a;
        size_t a;
        void (^block)(NSString *,NSString *);
        """
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let assign = ocparser.ast.globalStatements[0] as? DeclareAssignExpression;
        XCTAssert(assign?.declare.type.type == SpecialTypeInt)
        XCTAssert(assign?.declare.name == "a")
        
        let assign1 = ocparser.ast.globalStatements[1] as? DeclareAssignExpression;
        XCTAssert(assign1?.declare.type.type == SpecialTypeInt)
        XCTAssert(assign1?.declare.type.isPointer == true)
        
        let assign2 = ocparser.ast.globalStatements[2] as? DeclareAssignExpression;
        XCTAssert(assign2?.declare.type.type == SpecialTypeUInt)
        
        let assign3 = ocparser.ast.globalStatements[3] as? DeclareAssignExpression;
        XCTAssert(assign3?.declare.type.type == SpecialTypeChar)
        
        let assign4 = ocparser.ast.globalStatements[4] as? DeclareAssignExpression;
        XCTAssert(assign4?.declare.type.type == SpecialTypeUChar)
        
        let assign5 = ocparser.ast.globalStatements[5] as? DeclareAssignExpression;
        XCTAssert(assign5?.declare.type.type == SpecialTypeLong)
        
        let assign6 = ocparser.ast.globalStatements[6] as? DeclareAssignExpression;
        XCTAssert(assign6?.declare.type.type == SpecialTypeULong)
        
        let assign7 = ocparser.ast.globalStatements[7] as? DeclareAssignExpression;
        XCTAssert(assign7?.declare.type.type == SpecialTypeLongLong)
        
        let assign8 = ocparser.ast.globalStatements[8] as? DeclareAssignExpression;
        XCTAssert(assign8?.declare.type.type == SpecialTypeULongLong)
        
        let assign9 = ocparser.ast.globalStatements[9] as? DeclareAssignExpression;
        XCTAssert(assign9?.declare.type.type == SpecialTypeLong)
        
        let assign10 = ocparser.ast.globalStatements[10] as? DeclareAssignExpression;
        XCTAssert(assign10?.declare.type.type == SpecialTypeULong)
        
        let assign11 = ocparser.ast.globalStatements[11] as? DeclareAssignExpression;
        XCTAssert(assign11?.declare.type.type == SpecialTypeUInt)
        
        let assign12 = ocparser.ast.globalStatements[12] as? DeclareAssignExpression;
        XCTAssert(assign12?.declare.type.type == SpecialTypeBlock)
        XCTAssert(assign12?.declare.name == "block")
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
