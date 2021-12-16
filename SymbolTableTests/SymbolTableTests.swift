//
//  SymbolTableTests.swift
//  SymbolTableTests
//
//  Created by Jiang on 2021/11/21.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

import XCTest
import oc2mangoLib

class SymbolTableTests: XCTestCase {
    var parser = SymbolParser.init()
    override func setUpWithError() throws {
        parser = SymbolParser.init();
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAtClassDecls() throws {
        let source =
        """
        @class TestClass,TestClass1;
        @class NSObject1;
        """
        parser.parseSource(source)
        XCTAssert(symbolTableRoot.lookup("TestClass").decl.isClassRef())
        XCTAssert(symbolTableRoot.lookup("TestClass1").decl.isClassRef())
        XCTAssert(symbolTableRoot.lookup("NSObject1").decl.isClassRef())
    }
    func testDetectUndefineClass() throws{
        let source =
        """
        @class TestObject1;
        @interface TestObject: NSObject
        @property(nonatomic, strong)TestObject4 *var1;
        @property(nonatomic, weak)TestObject5 *var2;
        @end
        @implementation TestObject
        - (TestObject1 *)newMethod:(TestObject2 *)arg{
            TestObject3 *var = [TestObject3 new];
            [arg callMethod];
            return nil;
        }
        @end
        """
        parser.parseSource(source)
        XCTAssert(symbolTableRoot.lookup("TestObject1").decl.isClassRef())
        XCTAssert(symbolTableRoot.lookup("TestObject2").decl.isClassRef())
        XCTAssert(symbolTableRoot.lookup("TestObject3").decl.isClassRef())
        XCTAssert(symbolTableRoot.lookup("TestObject4").decl.isClassRef())
        XCTAssert(symbolTableRoot.lookup("TestObject5").decl.isClassRef())
    }
    
    func testStackMemoryAlloc() {
        let source =
        """
        struct CGRect{
            double x;
            double y;
            double width;
            double height;
        };
        @implementation TestObject
        - (id)newMethod:(int)arg rect:(CGRect)rect{
            double c = 0;
            CGRect d;
            return nil;
        }
        @end
        """
        let ast = parser.parseSource(source)
        let class1 = ast.classCache["TestObject"] as! ORClassNode
        let node = class1.methods.firstObject as! ORMethodNode
//        XCTAssert(node.scope.lookup("self").decl.index == 0)
//        XCTAssert(node.scope.lookup("sel").decl.index == 8)
//        XCTAssert(node.scope.lookup("arg").decl.index == 16)
//        XCTAssert(node.scope.lookup("rect").decl.index == 24)
//        XCTAssert(node.scope.lookup("c").decl.index == 56)
//        XCTAssert(node.scope.lookup("d").decl.index == 64)
        
    }
    
    


}
