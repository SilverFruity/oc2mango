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
@property (weak,strong) NSMutableArray *protocolNames;
@property (readwrite,readonly) BOOL isCategory;
@property (copy) void (^block)(void);
@property void (^block)(void);
@property NSString *name;
@property (copy,assign) void (^block)();
@end
"""
        ocparser.parseSource(source)

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
