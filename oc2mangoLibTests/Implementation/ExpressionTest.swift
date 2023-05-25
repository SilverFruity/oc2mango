//
//  ExpressionTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class ExpressionTest: XCTestCase {
    let parser = Parser()
    var source = ""
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        
    }
    func testDeclarePointerCheck(){
        source =
        """
        int ***a;
        ini x = sizeof(a);
        float b = 0.1f;
        float c = 0.111;
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let assign = ast.globalStatements[0] as? ORDeclareExpression
        XCTAssert(assign?.pair.var.ptCount == 3)
        XCTAssert(assign?.pair.var.varname == "a",assign?.pair.var.varname ?? "")
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
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())

        let assign = ast.globalStatements[0] as? ORDeclareExpression;
        XCTAssert(assign?.pair.type.type == TypeInt)
        XCTAssert(assign?.pair.var.varname == "a")
        
        let assign1 = ast.globalStatements[1] as? ORDeclareExpression;
        XCTAssert(assign1?.pair.type.type == TypeInt)


        let assign2 = ast.globalStatements[2] as? ORDeclareExpression;
        XCTAssert(assign2?.pair.type.type == TypeUInt)
        
        let assign3 = ast.globalStatements[3] as? ORDeclareExpression;
        XCTAssert(assign3?.pair.type.type == TypeChar)
        
        let assign4 = ast.globalStatements[4] as? ORDeclareExpression;
        XCTAssert(assign4?.pair.type.type == TypeUChar)
        
        let assign5 = ast.globalStatements[5] as? ORDeclareExpression;
        XCTAssert(assign5?.pair.type.type == TypeLong)
        
        let assign6 = ast.globalStatements[6] as? ORDeclareExpression;
        XCTAssert(assign6?.pair.type.type == TypeULong)
        
        let assign7 = ast.globalStatements[7] as? ORDeclareExpression;
        XCTAssert(assign7?.pair.type.type == TypeLongLong)
        
        let assign8 = ast.globalStatements[8] as? ORDeclareExpression;
        XCTAssert(assign8?.pair.type.type == TypeULongLong)
        
        let assign9 = ast.globalStatements[9] as? ORDeclareExpression;
        XCTAssert(assign9?.pair.type.type == TypeLongLong)
        
        let assign10 = ast.globalStatements[10] as? ORDeclareExpression;
        XCTAssert(assign10?.pair.type.type == TypeULongLong)
        
        let assign11 = ast.globalStatements[11] as? ORDeclareExpression;
        XCTAssert(assign11?.pair.type.type == TypeUInt)
        
        let assign12 = ast.globalStatements[12] as? ORDeclareExpression
        XCTAssert(assign12?.pair.var.isBlock == true)
        XCTAssert(assign12?.pair.var.varname == "block")
        
        let assign13 = ast.globalStatements[13] as? ORDeclareExpression
        XCTAssert(assign13?.pair.type.type == TypeObject,"\(assign13?.pair.type.type)")
        
        let assign14 = ast.globalStatements[14] as? ORDeclareExpression
        XCTAssert(assign14?.pair.type.type == TypeObject)
        XCTAssert(assign14?.pair.type.name == "NSObject")
        
        let assign15 = ast.globalStatements[15] as? ORDeclareExpression
        XCTAssert(assign15?.pair.type.type == TypeObject)
        XCTAssert(assign15?.pair.type.name == "NSMutableArray")
        
        let assign16 = ast.globalStatements[16] as? ORDeclareExpression
        XCTAssert(assign16?.pair.type.type == TypeObject)
        let expresssion16 = assign16?.expression as? ORValueExpression
        XCTAssert(expresssion16?.value_type == OCValueString)
        XCTAssert(expresssion16?.value as? String == "123")
        
        let assign17 = ast.globalStatements[17] as? ORDeclareExpression
        XCTAssert(assign17?.pair.var.ptCount == 1)
        XCTAssert(assign17?.pair.var.varname == "a",assign17?.pair.var.varname ?? "")
    }
    
    func testIgnoreTypePropertyKeyworkd(){
        source =
        """
        extern int a;
        static int a;
        const int a;
        int * const a;
        
        __strong id a;
        __weak id a;
        __block id a;
        __unused id a;
        id a = (id)b;
        id a = (__bridge_transfer id)b;
        id a = (__bridge_retained id)b;
        int * _Nonnull a;
        int * __autoreleasing a;
        int * _Nullable a;
        """
        let ast = parser.parseSource(source);
        XCTAssert(parser.isSuccess())
    }
    func testPointExpression(){
        source = """
        **a = c;
        *a = b;
        a = *x;
        a *= b;
        a = x * 0.11;
        a = x * 1;
        void (*test)(void) = b;
        a = x * c * 1;
        a = x * 1 * c;
        a = x * b;
        a = (*x) * (*b);
        """
        let ast = parser.parseSource(source);
        XCTAssert(parser.isSuccess())
        let convert = Convert()
        let result = convert.convert(ast.globalStatements[7] as Any)
        XCTAssert(result == "a = x * c * 1;",result)
        let result1 = convert.convert(ast.globalStatements[8] as Any)
        XCTAssert(result1 == "a = x * 1 * c;",result1)
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
        let ast = parser.parseSource(source);
        XCTAssert(parser.isSuccess())
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
        a = (NSObject *)a;
        @{@"key": @"value", x.z : [Object new]};
        @[value1,value2];
        
        """ 
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
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
        let ast = parser.parseSource(source);
        XCTAssert(parser.isSuccess())
        let exps = ast.globalStatements as! [ORBinaryExpression]
        XCTAssert(exps[0].operatorType == BinaryOperatorLT)
        let exp2 = exps[1]
        XCTAssert(exp2.operatorType == BinaryOperatorLOGIC_AND)
        let exp2Left = exp2.left as? ORBinaryExpression
        let exp2Rigth = exp2.right as? ORBinaryExpression
        XCTAssert(exp2Left?.operatorType == BinaryOperatorLT)
        XCTAssert(exp2Rigth?.operatorType == BinaryOperatorGT)
        
        let exp3 = exps[2]
        XCTAssert(exp3.operatorType == BinaryOperatorLOGIC_OR)
        
        let exp3l = exp3.left as? ORBinaryExpression
        let exp3r = exp3.right as? ORBinaryExpression
        
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
        let ast = parser.parseSource(source);
        XCTAssert(parser.isSuccess())
        
        
    }
    func testPointerAndTypeConvert(){
        source =
        """
        func(1 * a);
        a = (void(^)(int))a;
        for (id a in (NSArray *)value){ }
        id a = (type *)b * a;
        id a = (NSObject *)a;
        id a = (__bridge NSObject)a;
        id a = (NSObject)a;
        float q = 1.0f - (idx * 0.1f);
        *a = b;
        a = *x;
        NSString *a = 1;
        NSString *b = a * (b + c);
        funcsss(a * b);
        void funcs(NSString *a, NSString *b);
        [object method:self.x * 1.0];
        [object method:self.x * 1.0 param:self.x * self.y callback:^NSString *{
            return @"";
        }];
        void *function(type *a, type *b);
        CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.666);
        CGPointMake(CGRectGetMaxX(pathRect) * cLocations * 1, CGRectGetMidY(pathRect));
        """
        let ast = parser.parseSource(source);
        XCTAssert(parser.isSuccess())
        let call = ast.globalStatements as! [Any]
        let call1 = call.first! as! ORCFuncCall
        XCTAssert(call1.caller.value as! String == "func")
        XCTAssert(call1.expressions.count == 1)
        let binary = call1.expressions[0] as! ORBinaryExpression
        XCTAssert(binary.operatorType == BinaryOperatorMulti)
    }
    func testBlock(){
        source =
        """
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_global_queue(0, 0), ^{
            retValue = YES;
            dispatch_semaphore_signal(semaphore);
        });
        """
        let ast = parser.parseSource(source);
        XCTAssert(parser.isSuccess())
        let call = (ast.globalStatements as! [Any]).first! as! ORCFuncCall
        let param2 = call.expressions[2] as! ORFunctionImp
        XCTAssert(param2.declare.funVar.isBlock == true)
        XCTAssert(param2.declare.returnType.type.type == TypeVoid)
        XCTAssert(param2.declare.funVar.pairs.count == 0)
    }
    func testChineseStringWithQuotation(){
        source =
        """
        NSString *str = @"库\\"";
        NSString *str = @"库 \\"";
        """
        let ast = parser.parseSource(source);
        XCTAssert(parser.isSuccess())
    }
}
