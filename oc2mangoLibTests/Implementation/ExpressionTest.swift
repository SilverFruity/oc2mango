//
//  ExpressionTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class ExpressionTest: XCTestCase {
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
        id <protocol> a;
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
    
    
    func testCalculateExpression() {
        source =
        """
        x - 1 * 2;
        (y - 1) * 2;
        x->a - 1 + 2;
        """
        ocparser.parseSource(source);
        XCTAssert(ocparser.isSuccess())
        let cal1 = ocparser.ast.globalStatements[0] as? BinaryExpression;
        let left1 = cal1?.left as? BinaryExpression
        let righ1 = cal1?.right as? OCValue
        XCTAssert(cal1?.operatorType == BinaryOperatorMulti)
        XCTAssert(left1?.operatorType == BinaryOperatorAdd)
        XCTAssert(righ1 != nil)
        
    }
    
    func testJudgmentExpression(){
        source =
        """
        x < 1;
        id <protoocl> a;
        
        a->x;
        a - 1;
        x < a++;
        (x < 1 && x > 1) || ( x > 1 && x <= 1);
        """
        ocparser.parseSource(source);
        XCTAssert(ocparser.isSuccess())
    }
    
    func testPrimaryExpression(){
        source =
        """
        object;
        object.x;
        object->x;
        0;
        0.11;
        nil;
        NULL;
        @"test";
        self;
        super;
        @selector(new);
        @protocol(NSObject);
        ^{};
        ^(NSString *name,NSObject *object){};
        ^void {};
        ^void (NSString *name,NSObject *object){};
        *a;
        &b;
        @(10);
        @(10.00);
        @10;
        @10.01
        [NSObject new];
        (NSObject *)[NSObject new];
        (__bridge id)object;
        """
        ocparser.parseSource(source);
        XCTAssert(ocparser.isSuccess())
    }
    func testExpressionPriority(){
        
        
    }

}
