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
    let parser = Parser()
    var visitor = SymbolTableVisitor()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        visitor = SymbolTableVisitor()
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
        let ast = parser.parseSource(source)
        for node in ast.nodes {
            visitor.visit(node as! ORNode)
        }
        XCTAssert(symbolTableRoot.lookup("TestClass").decl.isClassRef())
        XCTAssert(symbolTableRoot.lookup("TestClass1").decl.isClassRef())
        XCTAssert(symbolTableRoot.lookup("NSObject1").decl.isClassRef())
    }
    func testDetectUndefineClass() throws{
        let source =
        """
        @class TestObject1,TestObject2;
        @interface TestObject: NSObject
        @property(nonatomic, strong)TestObject4 *var1;
        @property(nonatomic, weak)TestObject5 *var2;
        @end
        @implementation TestObject
        - (TestObject1 *)newMethod:(TestObject2 *)arg{
            TestObject3 *var = [TestObject3 new];
            return nil;
        }
        @end
        """
        let ast = parser.parseSource(source)
        for node in ast.nodes {
            visitor.visit(node as! ORNode)
        }
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
        for node in ast.nodes {
            visitor.visit(node as! ORNode)
        }
        let class1 = ast.classCache["TestObject"] as! ORClassNode
        let node = class1.methods.firstObject as! ORMethodNode
        XCTAssert(node.scope.lookup("self").decl.offset == 0)
        XCTAssert(node.scope.lookup("sel").decl.offset == 8)
        XCTAssert(node.scope.lookup("arg").decl.offset == 16)
        XCTAssert(node.scope.lookup("rect").decl.offset == 24)
        XCTAssert(node.scope.lookup("c").decl.offset == 56)
        XCTAssert(node.scope.lookup("d").decl.offset == 64)
        
    }
    
    


}
