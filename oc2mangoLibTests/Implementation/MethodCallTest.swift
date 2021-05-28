//
//  MethodCallTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/10.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class MethodCallTest: XCTestCase {
    let parser = Parser()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    func testMethodCall() {
        let source =
"""
[[NSObject new] test];
[self setValue:self forKey:value forKey:value forKey:value];

[[object valueForKey:@"key"] object];
[[object setValue:self forKey:@"name"] test:@"string"];
[object setValue:[NSObject new]];
[object setValue:[NSObject new].x];

[[self.x method].y method1];
[[self.x method].y method1].x;
self.callback(self,@(20),@"123");

make.top.equalTo(back.mas_bottom);
make.left.right.equalTo(self.view);
make.height.equalTo(@(240));
completion(httpReponse,result,error);

[object setCallBack:^(NSString *name){ }];
[self.chartView mas_makeConstraints:^(NSConstraintMaker *make) {
    make.top.equalTo(back.mas_bottom);
    make.left.right.equalTo(self.view);
    make.height.equalTo(@(240));
}];
"""
        parser.parseSource(source)
        XCTAssert(parser.isSuccess())
    }

    func testClassCacheSort(){
        let class0 = ORClass.init(className: "Class0")
        class0.superClassName = "NSObject"
        let class1 = ORClass.init(className: "Class1")
        class1.superClassName = class0.className
        let class2 = ORClass.init(className: "Class2")
        class2.superClassName = class1.className
        let class3 = ORClass.init(className: "Class3")
        class3.superClassName = class1.className
        let class4 = ORClass.init(className: "Class4")
        class4.superClassName = class0.className
        let class5 = ORClass.init(className: "Class5")
        class5.superClassName = class3.className
        let arrs = [class0,class1,class2,class3,class4,class5]
        var dict = [String:ORClass]()
        for item in arrs {
            dict[item.className] = item
        }
        let ast = AST.init()
        ast.classCache = NSMutableDictionary.init(dictionary: dict)
        XCTAssert(startClassProrityDetect(ast,class0) == 0)
        XCTAssert(startClassProrityDetect(ast,class1) == 1)
        XCTAssert(startClassProrityDetect(ast,class2) == 2)
        XCTAssert(startClassProrityDetect(ast,class3) == 2)
        XCTAssert(startClassProrityDetect(ast,class4) == 1)
        XCTAssert(startClassProrityDetect(ast,class5) == 3)
        let prorityDict = ["Class0":0,"Class1":1,"Class4":1,"Class3":2,"Class2":2,"Class5":3]
        let results = ast.sortClasses() as [Any]
        let prorities = results.map { (object) -> Int in
            prorityDict[(object as! ORClass).className]!
        }
        XCTAssert(prorities == [0, 1, 1, 2, 2, 3])
    }
}
