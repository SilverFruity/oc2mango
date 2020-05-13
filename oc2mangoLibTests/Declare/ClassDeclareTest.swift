//
//  ClassDeclareTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/5.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class ClassDeclareTest: XCTestCase {
    let ocparser = Parser.shared()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ocparser.clear()
    }
    func testFunction(){
        let source =
"""
void (*func)(NSString a, int b);
void func(NSString *a, int *b){

}
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        
    }
    func testNormalDeclare(){
        let source =
"""
@implementation Demo
- (instancetype)initWithBaseUrl:(NSURL *)baseUrl{ }
- (NSString *)method2:(void(^)(NSString *name))callback{ }
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let methodImp = ocparser.ast.class(forName: "Demo").methods[0] as? ORMethodImplementation
        XCTAssert(methodImp?.declare.methodNames == ["initWithBaseUrl"])
        XCTAssert(methodImp?.declare.isClassMethod == false)
        XCTAssert(methodImp?.declare.returnType.type.type == TypeObject)
        
        var methodImp1 = ocparser.ast.class(forName: "Demo").methods[1] as? ORMethodImplementation
        XCTAssert(methodImp1?.declare.methodNames == ["method2"])
        XCTAssert(methodImp1?.declare.isClassMethod == false)
        XCTAssert(methodImp1?.declare.returnType.type.type == TypeObject)
    }
    
    func testCategoryDeclare(){
        let source =
"""
@interface Demo (Category)
@end
"""
        ocparser.parseSource(source)
    }
    func testPropertyDeclare(){
        let source =
"""
@interface Demo: NSObject
@property (nonatomic,atomic) NSString *className;
@property (nonatomic,atomic) void (^name)(void);
@end
"""
        ocparser.parseSource(source)
        let occlass = ocparser.ast.class(forName: "Demo")
        let prop = occlass.properties.firstObject as! ORPropertyDeclare
        XCTAssert(ocparser.isSuccess())
//        XCTAssert(prop.var.name == "className")
//        XCTAssert(prop.var.type.type == TypeObject)
//        XCTAssert(prop.keywords == ["nonatomic","atomic"])
    }
    func testProtocolDeclare(){
        
                let source =
        """

        @protocol Demo <NSObject>
        @property (nonatomic,atomic) NSString *className;
        @property (nonatomic,atomic) void (^name)(void);
        @end
        """
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
    }

}
