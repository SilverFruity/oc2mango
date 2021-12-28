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
    func testFileSha256(){
        source =
        """
        int a;
        int *a;
        unsigned int a;
        char a;
        unsigned char a;
        long a;
        unsigned long a;
        long long a;
        unsigned long long a;
        NSInteger a;
        NSUInteger a;
        size_t a;
        void (^block)(NSString *,NSString *);
        id <NSObject> a;
        NSObject <NSObject> *a;
        NSMutableArray <NSObject *> *array;
        NSString *x = @"123";
        int* (*a)(int a, int b);
        NSURLSessionDataTask* (^resumeTask)(int *a);
        int ***a;
        int a=0,b=0,c=0;
        int a,b,c=0;
        NSURLSessionDataTask* (^resumeTask)(int *a) = ^{
        
        };
        
        NSURLSessionDataTask* (^resumeTask)(int a) = ^NSURLSessionDataTask *(int a){
            return task;
        };

        NSURLSessionDataTask* (^resumeTask)(void) = ^NSURLSessionDataTask *{
        
        };
        """
        let ast = parser.parseSource(source)
        let nodes = ast.nodes as! [Any]
        XCTAssert(parser.isSuccess())

        let assign = nodes[0] as? ORDeclaratorNode;
        XCTAssert(assign?.type.type == OCTypeInt)
        XCTAssert(assign?.var.varname == "a")
        
        let assign1 = nodes[1] as? ORDeclaratorNode;
        XCTAssert(assign1?.type.type == OCTypeInt)


        let assign2 = nodes[2] as? ORDeclaratorNode;
        XCTAssert(assign2?.type.type == OCTypeUInt)
        
        let assign3 = nodes[3] as? ORDeclaratorNode;
        XCTAssert(assign3?.type.type == OCTypeChar)
        
        let assign4 = nodes[4] as? ORDeclaratorNode;
        XCTAssert(assign4?.type.type == OCTypeUChar)
        
        let assign5 = nodes[5] as? ORDeclaratorNode;
        XCTAssert(assign5?.type.type == OCTypeLong)
        
        let assign6 = nodes[6] as? ORDeclaratorNode;
        XCTAssert(assign6?.type.type == OCTypeULong)
        
        let assign7 = nodes[7] as? ORDeclaratorNode;
        XCTAssert(assign7?.type.type == OCTypeLongLong)
        
        let assign8 = nodes[8] as? ORDeclaratorNode;
        XCTAssert(assign8?.type.type == OCTypeULongLong)
        
        let assign9 = nodes[9] as? ORDeclaratorNode;
        XCTAssert(assign9?.type.type == OCTypeLongLong)
        
        let assign10 = nodes[10] as? ORDeclaratorNode;
        XCTAssert(assign10?.type.type == OCTypeULongLong)
        
        let assign11 = nodes[11] as? ORDeclaratorNode;
        XCTAssert(assign11?.type.type == OCTypeUInt)
        
        let assign12 = nodes[12] as? ORDeclaratorNode
        XCTAssert(assign12?.var.isBlock == true)
        XCTAssert(assign12?.var.varname == "block")
        
        let assign13 = nodes[13] as? ORDeclaratorNode
        XCTAssert(assign13?.type.type == OCTypeObject,"\(assign13?.type.type)")
        
        let assign14 = nodes[14] as? ORDeclaratorNode
        XCTAssert(assign14?.type.type == OCTypeObject)
        XCTAssert(assign14?.type.name == "NSObject")
        
        let assign15 = nodes[15] as? ORDeclaratorNode
        XCTAssert(assign15?.type.type == OCTypeObject)
        XCTAssert(assign15?.type.name == "NSMutableArray")
        
        let assign16 = nodes[16] as? ORInitDeclaratorNode
        XCTAssert(assign16?.declarator.type.type == OCTypeObject)
        let expresssion16 = assign16?.expression as? ORValueNode
        XCTAssert(expresssion16?.value_type == OCValueString)
        XCTAssert(expresssion16?.value as? String == "123")
        
        let assign17 = nodes[17] as? ORDeclaratorNode
        XCTAssert(assign17?.var.ptCount == 1)
        XCTAssert(assign17?.var.varname == "a",assign17?.var.varname ?? "")
    }

}
