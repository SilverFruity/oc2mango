//
//  StatementTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class StatementTest: XCTestCase {
    let ocparser = Parser.shared()
    override func setUp() {
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testIfStatement(){
        let source =
"""
@implementation Demo
- (Demo *)objectMethod{
    if (x >= 0 ){
        [[self.x method].y method];
    }else if ( x == 0 ){
        [[self.x method].y method];
    }else{
        [[self.x method].y method];
    }
}
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.error == nil)
        ocparser.clear()
    }
    func testDoWhileStatement(){
        let source =
"""
@implementation Demo
- (Demo *)objectMethod{
    do{
        
    }while((x > 0) && (x < 0))
}
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.error == nil)
        
        ocparser.clear()
    }
    func testWhileStatement(){
        let source =
"""
@implementation Demo
- (Demo *)objectMethod{
    while((x > 0) && (x < 0)){

    }
}
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.error == nil);
        
        ocparser.clear()
    }
    func testSwitchStatement(){
        let source =
"""
@implementation Demo
- (Demo *)objectMethod{
    int x = 0;
    switch (x) {
        case 1:
        {
            NSString *name;
            break;
        }
        case 2:
        {
            NSString *name;
            break;
        }
            
        default:
        {
            NSString *name;
            break;
        }
    }
}
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.error == nil);
        ocparser.clear()
    }
    func testForStatement(){
        let source =
        """
@implementation Demo
- (Demo *)objectMethod{
    NSMutableArray *array = [NSMutableArray array];
    for (int x = 0; x++; x < 10) {
        [array addObject:[NSObject new]];
    }
}
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.error == nil);
        ocparser.clear()
    }
    
    func testForInStatement(){
        let source =
 """
@implementation Demo
- (Demo *)objectMethod{
    for (UIView *view in self.view.subviews) {
        [view addSubview:[UIView new]];
    }
}
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.error == nil);
        ocparser.clear()
    }
}
