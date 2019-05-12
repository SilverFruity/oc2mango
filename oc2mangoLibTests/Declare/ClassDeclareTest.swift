//
//  ClassDeclareTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/5.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class ClassDeclareTest: XCTestCase {
    let ocparser = Parser.shared()!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNormalDeclare(){
        let source =
"""
@interface Demo: NSObject
- (instancetype)initWithBaseUrl:(NSURL *)baseUrl;
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.classInterfaces.count == 1)
        XCTAssert(ocparser.error == nil)
        let declare: ClassDeclare = ocparser.classInterfaces?.firstObject as! ClassDeclare
        XCTAssert(declare.categoryName == nil)
        XCTAssert(declare.className == "Demo")
        XCTAssert(declare.superClassName == "NSObject")
        XCTAssert(declare.isCategory == false)
        ocparser.clear()
        
    }
    
    func testCategoryDeclare(){
        let source =
"""
@interface Demo (Category)
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.classInterfaces.count == 1)
        print(ocparser.classInterfaces)
        let declare: ClassDeclare = ocparser.classInterfaces[0] as! ClassDeclare
        XCTAssert(declare.categoryName == "Category")
        XCTAssert(declare.className == "Demo")
        XCTAssert(declare.superClassName == nil)
        XCTAssert(declare.isCategory == true)
        ocparser.clear()
    }
    func testPropertyDeclare(){
        let source =
"""
@interface Demo: NSObject
@property (nonatomic,atomic) NSString *className;
@property (weak,strong) NSMutableArray *protocolNames;
@property (readwrite,readonly) BOOL isCategory;
@property (copy) void (^block)(void);
@property void (^block)(void);
@property NSString *name;
@property (copy,assign) void (^block)();
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.classInterfaces.count == 1)
        if let declare = ocparser.classInterfaces?.firstObject as? ClassDeclare {
            let propertyFirst = declare.properties[0] as! PropertyDeclare
            XCTAssert(propertyFirst.keywords == ["nonatomic","atomic"])
            XCTAssert(propertyFirst.var.type.type == SpecialTypeObject)
            XCTAssert(propertyFirst.var.name == "className")
            
            let propertyLast = declare.properties.lastObject as! PropertyDeclare
            XCTAssert(propertyLast.keywords == ["copy","assign"])
            XCTAssert(propertyLast.var.type.type == SpecialTypeBlock)
            XCTAssert(propertyLast.var.name == "block")
        }
        ocparser.clear()
    }
    
    func testMethodDeclare(){
        let source =
"""
@interface Demo: NSObject
- (NSString *)method2:(void(^)(NSString *name))callback;
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.classInterfaces.count == 1)
        let declare: ClassDeclare = ocparser.classInterfaces?.firstObject as! ClassDeclare
        let method = declare.methods.firstObject as! MethodDeclare
        XCTAssert(method.methodNames == ["method2"])
        XCTAssert(method.parameterNames == ["callback"])
        XCTAssert(method.returnType.type == SpecialTypeObject)
        let types = method.parameterTypes as! [TypeSpecial]
        XCTAssert(types.first!.type == SpecialTypeBlock)
        
        
        ocparser.clear()
        
    }

}
