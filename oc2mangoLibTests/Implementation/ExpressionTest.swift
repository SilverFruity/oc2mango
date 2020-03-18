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

    func testDeclareExpression(){
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
        id <NSObject> a;
        NSObject <NSObject> *a;
        NSMutableArray <NSObject *> *array;
        NSString *x = @"123";
        int* (*a)(int a, int b);
        NSURLSessionDataTask* (^resumeTask)(int *a);
        a = *x * b * 1;
        int ***a;
        int a=0,b=0,c=0;
        int a,b,c=0;
        NSURLSessionDataTask* (^resumeTask)(int *a) = ^{
        
        };
        
        NSURLSessionDataTask* (^resumeTask)(int a) = ^NSURLSessionDataTask *(int a){
            return task;
        };

        NSURLSessionDataTask* (^resumeTask)(void) = ^NSURLSessionDataTask *{
        
        };
        """
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())

        let assign = ocparser.ast.globalStatements[0] as? DeclareExpression;
        XCTAssert(assign?.type.type == TypeInt)
        XCTAssert(assign?.var.varname == "a")
        
        let assign1 = ocparser.ast.globalStatements[1] as? DeclareExpression;
        XCTAssert(assign1?.type.type == TypeInt)


        let assign2 = ocparser.ast.globalStatements[2] as? DeclareExpression;
        XCTAssert(assign2?.type.type == TypeUInt)
        
        let assign3 = ocparser.ast.globalStatements[3] as? DeclareExpression;
        XCTAssert(assign3?.type.type == TypeChar)
        
        let assign4 = ocparser.ast.globalStatements[4] as? DeclareExpression;
        XCTAssert(assign4?.type.type == TypeUChar)
        
        let assign5 = ocparser.ast.globalStatements[5] as? DeclareExpression;
        XCTAssert(assign5?.type.type == TypeLong)
        
        let assign6 = ocparser.ast.globalStatements[6] as? DeclareExpression;
        XCTAssert(assign6?.type.type == TypeULong)
        
        let assign7 = ocparser.ast.globalStatements[7] as? DeclareExpression;
        XCTAssert(assign7?.type.type == TypeLongLong)
        
        let assign8 = ocparser.ast.globalStatements[8] as? DeclareExpression;
        XCTAssert(assign8?.type.type == TypeULongLong)
        
        let assign9 = ocparser.ast.globalStatements[9] as? DeclareExpression;
        XCTAssert(assign9?.type.type == TypeLong)
        
        let assign10 = ocparser.ast.globalStatements[10] as? DeclareExpression;
        XCTAssert(assign10?.type.type == TypeULong)
        
        let assign11 = ocparser.ast.globalStatements[11] as? DeclareExpression;
        XCTAssert(assign11?.type.type == TypeUInt)
        
        let assign12 = ocparser.ast.globalStatements[12] as? DeclareExpression
        XCTAssert(assign12?.var.ptCount == -1)
        XCTAssert(assign12?.var.varname == "block")
        
        let assign13 = ocparser.ast.globalStatements[13] as? DeclareExpression
        XCTAssert(assign13?.type.type == TypeObject,"\(assign13?.type.type)")
        
        let assign14 = ocparser.ast.globalStatements[14] as? DeclareExpression
        XCTAssert(assign14?.type.type == TypeObject)
        XCTAssert(assign14?.type.name == "NSObject")
        
        let assign15 = ocparser.ast.globalStatements[15] as? DeclareExpression
        XCTAssert(assign15?.type.type == TypeObject)
        XCTAssert(assign15?.type.name == "NSMutableArray")
        
        let assign16 = ocparser.ast.globalStatements[16] as? DeclareExpression
        XCTAssert(assign16?.type.type == TypeObject)
        let expresssion16 = assign16?.expression as? OCValue
        XCTAssert(expresssion16?.value_type == OCValueString)
        XCTAssert(expresssion16?.value as? String == "123")
        
        let assign17 = ocparser.ast.globalStatements[17] as? DeclareExpression
        XCTAssert(assign17?.var.ptCount == 1)
        XCTAssert(assign17?.var.varname == "a",assign17?.var.varname ?? "")
    }
    
    
    func testBinaryExpression(){
        source =
        """
        x < 1;
        
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
        ^void *{};
        ^{};
        ^void {};
        ^int* (NSString *name,NSObject *object){};
        ^(NSString *name,NSObject *object){};
        *a;
        &b;
        @(10);
        @(10.00);
        @10;
        @10.01;
        [NSObject new];
        [NSObject value1:1 value2:2 value3:3 value4:4];
        [[self.x new].y test];
        (NSObject *)[NSObject new];
        @{@"key": @"value", x.z : [Object new]};
        @[value1,value2];
        
        """ 
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
    }
    func testAssignExpression(){
        
        
    }
    func testUnaryExpression(){
        
    }
    func testBinaryExpession(){
        source =
        """
        
        x < 1;
        x < 1 && b > 0;
        x.y && y->z || [NSObject new].x && [self.x isTrue];
        x == 1;
        x != 0;
        x - 1 * 2;
        (y - 1) * 2;
        x->a - 1 + 2;
        """
        ocparser.parseSource(source);
        XCTAssert(ocparser.isSuccess())
        let exps = ocparser.ast.globalStatements as! [BinaryExpression]
        XCTAssert(exps[0].operatorType == BinaryOperatorLT)
        let exp2 = exps[1]
        XCTAssert(exp2.operatorType == BinaryOperatorLOGIC_AND)
        let exp2Left = exp2.left as? BinaryExpression
        let exp2Rigth = exp2.right as? BinaryExpression
        XCTAssert(exp2Left?.operatorType == BinaryOperatorLT)
        XCTAssert(exp2Rigth?.operatorType == BinaryOperatorGT)
        
        let exp3 = exps[2]
        XCTAssert(exp3.operatorType == BinaryOperatorLOGIC_OR)
        
        let exp3l = exp3.left as? BinaryExpression
        let exp3r = exp3.right as? BinaryExpression
        
        XCTAssert(exp3l?.operatorType == BinaryOperatorLOGIC_AND)
        XCTAssert(exp3r?.operatorType == BinaryOperatorLOGIC_AND)
        XCTAssert(exps[3].operatorType == BinaryOperatorEqual)
        XCTAssert(exps[4].operatorType == BinaryOperatorNotEqual)
        XCTAssert(exps[5].operatorType == BinaryOperatorSub)
        XCTAssert(exps[6].operatorType == BinaryOperatorMulti)
        XCTAssert(exps[7].operatorType == BinaryOperatorAdd)
        
    }
    func testTernaryExpression(){
        
        source =
        """
        int x = y == nil ? 0 : 1;
        x = y?:1;
        """
        ocparser.parseSource(source);
        XCTAssert(ocparser.isSuccess())
        
        
    }
}
