//
//  FileTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/12.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class FileTest: XCTestCase {
    let parser = Parser()
    var source = ""
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testFile1() {
        let bundle = Bundle.init(for: FileTest.classForCoder())
        let path = bundle.path(forResource: "TestSource", ofType: "imp")
        let data = try? Data.init(contentsOf:URL.init(fileURLWithPath: path!))
        let source = String.init(data: data ?? Data.init(), encoding: .utf8)
        parser.parseSource(source)
        XCTAssert(parser.isSuccess())
    }

}
