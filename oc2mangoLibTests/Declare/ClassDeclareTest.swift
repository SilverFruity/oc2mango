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

    func testNormalDeclare(){
        let source =
"""
@interface Demo: NSObject
- (instancetype)initWithBaseUrl:(NSURL *)baseUrl;
@end
"""
        ocparser.parseSource(source)
        
    }
    
    func testCategoryDeclare(){
        let source =
"""
@interface Demo (Category)
@end
"""
        ocparser.parseSource(source)
        ocparser.clear()
    }
    func testPropertyDeclare(){
        let source =
"""
@interface Demo: NSObject
@property (nonatomic,atomic) NSString *className;
@end
"""
        ocparser.parseSource(source)
        let occlass = ocparser.ast.class(forName: "Demo")
        let prop = occlass.properties.firstObject as! PropertyDeclare
        XCTAssert(ocparser.isSuccess())
        XCTAssert(prop.var.name == "className")
        XCTAssert(prop.var.type.type == SpecialTypeObject)
        XCTAssert(prop.keywords == ["nonatomic","atomic"])
        
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
        
        
        ocparser.clear()
        
    }

}
