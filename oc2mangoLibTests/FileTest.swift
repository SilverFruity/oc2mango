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
        let file = ORPatchFile.init(nodes: ast.nodes as! [Any])
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! + "/binarypatch"
        file.dump(asBinaryPatch: path)
        let binaryfile = ORPatchFile.loadBinaryPatch(path)
        
        guard let nodes = binaryfile?.nodes else {
            return
        }
        XCTAssert(parser.isSuccess())

        let assign = nodes[0] as? ORDeclareExpression;
        XCTAssert(assign?.pair.type.type == TypeInt)
        XCTAssert(assign?.pair.var.varname == "a")
        
        let assign1 = nodes[1] as? ORDeclareExpression;
        XCTAssert(assign1?.pair.type.type == TypeInt)


        let assign2 = nodes[2] as? ORDeclareExpression;
        XCTAssert(assign2?.pair.type.type == TypeUInt)
        
        let assign3 = nodes[3] as? ORDeclareExpression;
        XCTAssert(assign3?.pair.type.type == TypeChar)
        
        let assign4 = nodes[4] as? ORDeclareExpression;
        XCTAssert(assign4?.pair.type.type == TypeUChar)
        
        let assign5 = nodes[5] as? ORDeclareExpression;
        XCTAssert(assign5?.pair.type.type == TypeLong)
        
        let assign6 = nodes[6] as? ORDeclareExpression;
        XCTAssert(assign6?.pair.type.type == TypeULong)
        
        let assign7 = nodes[7] as? ORDeclareExpression;
        XCTAssert(assign7?.pair.type.type == TypeLongLong)
        
        let assign8 = nodes[8] as? ORDeclareExpression;
        XCTAssert(assign8?.pair.type.type == TypeULongLong)
        
        let assign9 = nodes[9] as? ORDeclareExpression;
        XCTAssert(assign9?.pair.type.type == TypeLongLong)
        
        let assign10 = nodes[10] as? ORDeclareExpression;
        XCTAssert(assign10?.pair.type.type == TypeULongLong)
        
        let assign11 = nodes[11] as? ORDeclareExpression;
        XCTAssert(assign11?.pair.type.type == TypeUInt)
        
        let assign12 = nodes[12] as? ORDeclareExpression
        XCTAssert(assign12?.pair.var.isBlock == true)
        XCTAssert(assign12?.pair.var.varname == "block")
        
        let assign13 = nodes[13] as? ORDeclareExpression
        XCTAssert(assign13?.pair.type.type == TypeObject,"\(assign13?.pair.type.type)")
        
        let assign14 = nodes[14] as? ORDeclareExpression
        XCTAssert(assign14?.pair.type.type == TypeObject)
        XCTAssert(assign14?.pair.type.name == "NSObject")
        
        let assign15 = nodes[15] as? ORDeclareExpression
        XCTAssert(assign15?.pair.type.type == TypeObject)
        XCTAssert(assign15?.pair.type.name == "NSMutableArray")
        
        let assign16 = nodes[16] as? ORDeclareExpression
        XCTAssert(assign16?.pair.type.type == TypeObject)
        let expresssion16 = assign16?.expression as? ORValueExpression
        XCTAssert(expresssion16?.value_type == OCValueString)
        XCTAssert(expresssion16?.value as? String == "123")
        
        let assign17 = nodes[17] as? ORDeclareExpression
        XCTAssert(assign17?.pair.var.ptCount == 1)
        XCTAssert(assign17?.pair.var.varname == "a",assign17?.pair.var.varname ?? "")
    }

}
