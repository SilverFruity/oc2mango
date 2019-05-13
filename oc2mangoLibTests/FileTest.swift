//
//  FileTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/12.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class FileTest: XCTestCase {
    let ocparser = Parser.shared()!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let bundle = Bundle.init(for: FileTest.classForCoder())
        let path = bundle.path(forResource: "TestSource", ofType: "imp")
        let data = try? Data.init(contentsOf:URL.init(fileURLWithPath: path!))
        let source = String.init(data: data ?? Data.init(), encoding: .utf8)
        ocparser.parseSource(source)
        XCTAssert(ocparser.source != nil)
        XCTAssert(ocparser.error == nil)
        for imp: ClassImplementation in ocparser.classImps as! [ClassImplementation] {
//            print(imp.methodImps.lastObject!)
        }
        print(ocparser.statements())
    }


}
