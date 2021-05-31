//
//  ClassDeclareTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/5.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class ClassDeclareTest: XCTestCase {
    let parser = Parser()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    func testIntegerValue(){
        let source =
        """
        long long value = 0xFFFFFFFF;
        unsigned long long value1 = 0xFFFFFFFFFFFFFFFF;
        """
        let ast = parser.parseSource(source)
        let value = ast.globalStatements[0] as! ORInitDeclaratorNode
        let value1 = ast.globalStatements[1] as! ORInitDeclaratorNode
        XCTAssert((value.expression as! ORIntegerValue).value == UINT32_MAX)
        XCTAssert((value1.expression as! ORUIntegerValue).value == UINT64_MAX)
    }
    func testFunction(){
        let source =
        """
void (*func)(NSString a, int b);
void func(NSString *a, int *b){

}
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        
    }
    func testNormalDeclare(){
        let source =
        """
@implementation Demo
- (instancetype)initWithBaseUrl:(NSURL *)baseUrl{ }
- (NSString *)method2:(void(^)(NSString *name))callback{ }
@end
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let methodImp = ast.class(forName: "Demo").methods[0] as? ORMethodNode
        XCTAssert(methodImp?.declare.methodNames == ["initWithBaseUrl"])
        XCTAssert(methodImp?.declare.isClassMethod == false)
        XCTAssert(methodImp?.declare.returnType.type.type == OCTypeObject)
        
        var methodImp1 = ast.class(forName: "Demo").methods[1] as? ORMethodNode
        XCTAssert(methodImp1?.declare.methodNames == ["method2"])
        XCTAssert(methodImp1?.declare.isClassMethod == false)
        XCTAssert(methodImp1?.declare.returnType.type.type == OCTypeObject)
    }
    
    func testCategoryDeclare(){
        let source =
        """
@interface Demo (Category)
@end
"""
        let ast = parser.parseSource(source)
    }
    func testPropertyDeclare(){
        let source =
        """
@interface Demo: NSObject
@property (nonatomic,atomic) NSString *className;
@property (nonatomic,atomic) void (^name)(void);
@end
"""
        let ast = parser.parseSource(source)
        let occlass = ast.class(forName: "Demo")
        let prop = occlass.properties.firstObject as! ORPropertyNode
        XCTAssert(parser.isSuccess())
        //        XCTAssert(prop.var.name == "className")
        //        XCTAssert(prop.var.type.type == OCTypeObject)
        //        XCTAssert(prop.keywords == ["nonatomic","atomic"])
    }
    func testClassConfirmProtocol(){
        let source =
        """
        @interface Demo ()<NSObject,NSObject>
        @property (nonatomic,atomic) NSString *className;
        @property (nonatomic,atomic) void (^name)(void);
        @end
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let classes = ast.classCache["Demo"] as! ORClassNode
        XCTAssert(classes.protocols == ["NSObject", "NSObject"])
    }
    
    func testEnumExpression(){
        var source =
        """
        enum Test{
            Value1,
            Value2,
            Value3
        };
        """
        var ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let exp = ast.globalStatements.firstObject as! OREnumStatNode
        XCTAssert(exp.valueType == OCTypeInt)
        XCTAssert(exp.fields.count == 3)
        XCTAssert(exp.fields[0] is ORValueNode)
        XCTAssert(exp.fields[1] is ORValueNode)
        XCTAssert(exp.fields[2] is ORValueNode)
        
        
        source =
        """
        enum Test: NSUInteger{
        Value1,
        Value2,
        Value3
        };
        """
        ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let secondExp = ast.globalStatements.firstObject as! OREnumStatNode
        XCTAssert(secondExp.valueType == OCTypeULongLong)
        XCTAssert(secondExp.enumName == "Test")
        XCTAssert(secondExp.fields.count == 3)
        XCTAssert(secondExp.fields[0] is ORValueNode)
        XCTAssert(secondExp.fields[1] is ORValueNode)
        XCTAssert(secondExp.fields[2] is ORValueNode)
        
        source =
        """
        enum : NSUInteger{
        Value1,
        Value2,
        Value3
        };
        """
        ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let thirdExp = ast.globalStatements.firstObject as! OREnumStatNode
        XCTAssert(thirdExp.valueType == OCTypeULongLong)
        XCTAssert(thirdExp.enumName == "")
        XCTAssert(thirdExp.fields.count == 3)
        XCTAssert(thirdExp.fields[0] is ORValueNode)
        XCTAssert(thirdExp.fields[1] is ORValueNode)
        XCTAssert(thirdExp.fields[2] is ORValueNode)
    }
    func testCArrayDeclare(){
        let source =
        """
        int a[100];
        int b[a.x];
        int a[];
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let exp = ast.globalStatements[0] as! ORCArrayDeclNode
        XCTAssert(exp.type.type == OCTypeInt)
        XCTAssert(exp.var.varname == "a")
        XCTAssert(exp.var.ptCount == 0)
        XCTAssert((exp.capacity as! ORIntegerValue).value == 100)
        let exp1 = ast.globalStatements[2] as! ORDeclaratorNode
        XCTAssert(exp1.type.type == OCTypeInt)
        XCTAssert(exp1.var.varname == "a")
        XCTAssert(exp1.var.ptCount == 1, "ptCount \(exp1.var.ptCount)")
    }
    func testUnionDeclare(){
        let source =
        """
        union CGPoint {
            CGFloat x;
            CGFloat y;
        };
        union CGPoint {
            CGFloat x,y;
        };
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let exp = ast.globalStatements.firstObject as! ORUnionStatNode
        let fields = exp.fields as! [ORDeclaratorNode]
        XCTAssert(fields.count == 2)
        XCTAssert(fields[0].type.type == OCTypeDouble)
        XCTAssert(fields[1].type.type == OCTypeDouble)
        XCTAssert(fields[0].var.varname == "x")
        XCTAssert(fields[1].var.varname == "y")
    }
    func testStructExpression(){
        let source =
        """
        struct CGPoint {
            CGFloat x;
            CGFloat y;
        };
        struct CGPoint {
            CGFloat x,y;
        };
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let exp = ast.globalStatements.firstObject as! ORStructStatNode
        let fields = exp.fields as! [ORDeclaratorNode]
        XCTAssert(fields.count == 2)
        XCTAssert(fields[0].type.type == OCTypeDouble)
        XCTAssert(fields[1].type.type == OCTypeDouble)
        XCTAssert(fields[0].var.varname == "x")
        XCTAssert(fields[1].var.varname == "y")
    }
    func testTypeDefExpression(){
        var source =
        """
        typedef int * value;
        """
        var ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let exp = ast.globalStatements.firstObject as! ORTypedefStatNode
        XCTAssert(exp.typeNewName == "value")
        let typepair = exp.expression as! ORDeclaratorNode
        XCTAssert(typepair.type.type == OCTypeInt)
        
        
        source =
        """
        typedef struct CGPoint {
        CGFloat x;
        CGFloat y;
        }Point;
        """
        ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let structTypeDef = ast.globalStatements.firstObject as! ORTypedefStatNode
        XCTAssert(structTypeDef.typeNewName == "Point")
        let structExp = structTypeDef.expression as! ORStructStatNode
        let fields = structExp.fields as! [ORDeclaratorNode]
        XCTAssert(fields.count == 2)
        XCTAssert(fields[0].type.type == OCTypeDouble)
        XCTAssert(fields[1].type.type == OCTypeDouble)
        XCTAssert(fields[0].var.varname == "x")
        XCTAssert(fields[1].var.varname == "y")
        
        
        source =
        """
        typedef enum UIControlEvents: NSUInteger{
        UIControlEventTouchDown                                         = 1 <<  0,      // on all touch downs
        UIControlEventTouchDownRepeat                                   = 1 <<  1,      // on multiple touchdowns (tap count > 1)
        UIControlEventTouchDragInside                                   = 1 <<  2,
        UIControlEventTouchDragOutside                                  = 1 <<  3,
        UIControlEventTouchDragEnter                                    = 1 <<  4,
        UIControlEventTouchDragExit                                     = 1 <<  5,
        UIControlEventTouchUpInside                                     = 1 <<  6,
        UIControlEventTouchUpOutside                                    = 1 <<  7,
        UIControlEventTouchCancel                                       = 1 <<  8,
        UIControlEventValueChanged                                      = 1 << 12,     // sliders, etc.
        UIControlEventEditingDidBegin                                   = 1 << 16,     // UITextField
        UIControlEventEditingChanged                                    = 1 << 17,
        UIControlEventEditingDidEnd                                     = 1 << 18,
        UIControlEventEditingDidEndOnExit                               = 1 << 19,     // 'return key' ending editing
        UIControlEventAllTouchEvents                                    = 0x00000FFF,  // for touch events
        UIControlEventAllEditingEvents                                  = 0x000F0000,  // for UITextField
        UIControlEventApplicationReserved                               = 0x0F000000,  // range available for application use
        UIControlEventSystemReserved                                    = 0xF0000000,  // range reserved for internal framework use
        UIControlEventAllEvents                                         = 0xFFFFFFFF
        }UIControlEvents;
        """
        ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let enumTypeDef = ast.globalStatements.firstObject as! ORTypedefStatNode
        XCTAssert(enumTypeDef.typeNewName == "UIControlEvents")
        let enumExp = enumTypeDef.expression as! OREnumStatNode
        let enumFields = enumExp.fields as! [ORAssignNode]
        XCTAssert(enumFields[0].varname() == "UIControlEventTouchDown")
        XCTAssert(enumFields[1].varname() == "UIControlEventTouchDownRepeat")
        XCTAssert(enumFields[2].varname() == "UIControlEventTouchDragInside")
        XCTAssert(enumFields[3].varname() == "UIControlEventTouchDragOutside")
        XCTAssert(enumFields[4].varname() == "UIControlEventTouchDragEnter")
        XCTAssert(enumFields[5].varname() == "UIControlEventTouchDragExit")
        XCTAssert(enumFields[6].varname() == "UIControlEventTouchUpInside")
        XCTAssert(enumFields[7].varname() == "UIControlEventTouchUpOutside")
        XCTAssert(enumFields[8].varname() == "UIControlEventTouchCancel")
        XCTAssert(enumFields[9].varname() == "UIControlEventValueChanged")
        XCTAssert(enumFields[10].varname() == "UIControlEventEditingDidBegin")
        XCTAssert(enumFields[11].varname() == "UIControlEventEditingChanged")
        XCTAssert(enumFields[12].varname() == "UIControlEventEditingDidEnd")
        XCTAssert(enumFields[13].varname() == "UIControlEventEditingDidEndOnExit")
        XCTAssert(enumFields[14].varname() == "UIControlEventAllTouchEvents")
        XCTAssert(enumFields[15].varname() == "UIControlEventAllEditingEvents")
        XCTAssert(enumFields[16].varname() == "UIControlEventApplicationReserved")
        XCTAssert(enumFields[17].varname() == "UIControlEventSystemReserved")
        XCTAssert(enumFields[18].varname() == "UIControlEventAllEvents")
        
    }
    func testMutilArgsDeclare(){
        let source =
        """

        void NSLog(NSString *format,...);
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let declare = ast.globalStatements.firstObject as! ORFunctionDeclNode
        XCTAssert(declare.var.varname == "NSLog")
        XCTAssert(declare.isMultiArgs)
    }
    
    func testDeclareProtcol(){
        let source =
        """

        @protocol Demo <NSObject,Test>
        @property (nonatomic,atomic) NSString *className;
        @property (nonatomic,atomic) void (^name)(void);
        @end
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let value = ast.protcolCache["Demo"] as! ORProtocolNode
        XCTAssert(value.protocols == ["NSObject","Test"])
    }
}
