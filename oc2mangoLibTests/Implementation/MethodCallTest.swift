//
//  MethodCallTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/10.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class MethodCallTest: XCTestCase {
    let ocparser = Parser.shared()!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMethodCall() {
        let source =
        """
@implementation Demo
- (Demo *)objectMethods{
    [[NSObject new] test];
    [[object valueForKey:@"key"] object];
    [[object setValue:self forKey:@"name"] test:@"string"];
    [object setValue:[NSObject new]];
    [object setValue:[NSObject new].x];
    
    [[self.x method].y method1];
    [[self.x method].y method1].x;

    [object setCallBack:^(NSString *name){ }];

    self.callback(self,@(20),@"123");
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(240));
    }];
    make.top.equalTo(back.mas_bottom);
    make.left.right.equalTo(self.view);
    make.height.equalTo(@(240));
}
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.classImps.count > 0);
        let classImp : ClassImplementation  = ocparser.classImps!.firstObject as! ClassImplementation
        let methodImp : MethodImplementation = classImp.methodImps!.firstObject as! MethodImplementation
        let funcImp : FunctionImp = methodImp.imp;
        XCTAssert(funcImp.expressions.count > 0);
        print(funcImp.expressions);
    }


}
