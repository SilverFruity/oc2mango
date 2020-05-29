//
//  ClassDeclareTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/5.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class ClassDeclareTest: XCTestCase {
    let ocparser = Parser.shared()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ocparser.clear()
    }
    func testFunction(){
        let source =
        """
void (*func)(NSString a, int b);
void func(NSString *a, int *b){

}
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        
    }
    func testNormalDeclare(){
        let source =
        """
@implementation Demo
- (instancetype)initWithBaseUrl:(NSURL *)baseUrl{ }
- (NSString *)method2:(void(^)(NSString *name))callback{ }
@end
"""
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let methodImp = ocparser.ast.class(forName: "Demo").methods[0] as? ORMethodImplementation
        XCTAssert(methodImp?.declare.methodNames == ["initWithBaseUrl"])
        XCTAssert(methodImp?.declare.isClassMethod == false)
        XCTAssert(methodImp?.declare.returnType.type.type == TypeObject)
        
        var methodImp1 = ocparser.ast.class(forName: "Demo").methods[1] as? ORMethodImplementation
        XCTAssert(methodImp1?.declare.methodNames == ["method2"])
        XCTAssert(methodImp1?.declare.isClassMethod == false)
        XCTAssert(methodImp1?.declare.returnType.type.type == TypeObject)
    }
    
    func testCategoryDeclare(){
        let source =
        """
@interface Demo (Category)
@end
"""
        ocparser.parseSource(source)
    }
    func testPropertyDeclare(){
        let source =
        """
@interface Demo: NSObject
@property (nonatomic,atomic) NSString *className;
@property (nonatomic,atomic) void (^name)(void);
@end
"""
        ocparser.parseSource(source)
        let occlass = ocparser.ast.class(forName: "Demo")
        let prop = occlass.properties.firstObject as! ORPropertyDeclare
        XCTAssert(ocparser.isSuccess())
        //        XCTAssert(prop.var.name == "className")
        //        XCTAssert(prop.var.type.type == TypeObject)
        //        XCTAssert(prop.keywords == ["nonatomic","atomic"])
    }
    func testProtocolDeclare(){
        let source =
        """
        @protocol Demo <NSObject>
        @property (nonatomic,atomic) NSString *className;
        @property (nonatomic,atomic) void (^name)(void);
        @end
        """
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
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
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let exp = ocparser.ast.globalStatements.firstObject as! OREnumExpressoin
        XCTAssert(exp.valueType == TypeInt)
        XCTAssert(exp.fields.count == 3)
        XCTAssert(exp.fields[0] is ORValueExpression)
        XCTAssert(exp.fields[1] is ORValueExpression)
        XCTAssert(exp.fields[2] is ORValueExpression)
        ocparser.clear()
        
        source =
        """
        enum Test: NSUInteger{
        Value1,
        Value2,
        Value3
        };
        """
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let secondExp = ocparser.ast.globalStatements.firstObject as! OREnumExpressoin
        XCTAssert(secondExp.valueType == TypeULongLong)
        XCTAssert(secondExp.enumName == "Test")
        XCTAssert(secondExp.fields.count == 3)
        XCTAssert(secondExp.fields[0] is ORValueExpression)
        XCTAssert(secondExp.fields[1] is ORValueExpression)
        XCTAssert(secondExp.fields[2] is ORValueExpression)
        
        source =
        """
        enum : NSUInteger{
        Value1,
        Value2,
        Value3
        };
        """
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let thirdExp = ocparser.ast.globalStatements.firstObject as! OREnumExpressoin
        XCTAssert(thirdExp.valueType == TypeULongLong)
        XCTAssert(thirdExp.enumName == "Test")
        XCTAssert(thirdExp.fields.count == 3)
        XCTAssert(thirdExp.fields[0] is ORValueExpression)
        XCTAssert(thirdExp.fields[1] is ORValueExpression)
        XCTAssert(thirdExp.fields[2] is ORValueExpression)
    }
    
    func testStructExpression(){
        let source =
        """
        struct CGPoint {
            CGFloat x;
            CGFloat y;
        };
        """
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let exp = ocparser.ast.globalStatements.firstObject as! ORStructExpressoin
        let fields = exp.fields as! [ORTypeVarPair]
        XCTAssert(fields.count == 2)
        XCTAssert(fields[0].type.type == TypeDouble)
        XCTAssert(fields[1].type.type == TypeDouble)
        XCTAssert(fields[0].var.varname == "x")
        XCTAssert(fields[1].var.varname == "y")
    }
    func testTypeDefExpression(){
        var source =
        """
        typedef int * value;
        """
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let exp = ocparser.ast.globalStatements.firstObject as! ORTypedefExpressoin
        XCTAssert(exp.typeNewName == "value")
        let typepair = exp.expression as! ORTypeVarPair
        XCTAssert(typepair.type.type == TypeInt)
        ocparser.clear()
        
        source =
        """
        typedef struct CGPoint {
        CGFloat x;
        CGFloat y;
        }Point;
        """
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let structTypeDef = ocparser.ast.globalStatements.firstObject as! ORTypedefExpressoin
        XCTAssert(structTypeDef.typeNewName == "Point")
        let structExp = structTypeDef.expression as! ORStructExpressoin
        let fields = structExp.fields as! [ORTypeVarPair]
        XCTAssert(fields.count == 2)
        XCTAssert(fields[0].type.type == TypeDouble)
        XCTAssert(fields[1].type.type == TypeDouble)
        XCTAssert(fields[0].var.varname == "x")
        XCTAssert(fields[1].var.varname == "y")
        ocparser.clear()
        
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
        ocparser.parseSource(source)
        XCTAssert(ocparser.isSuccess())
        let enumTypeDef = ocparser.ast.globalStatements.firstObject as! ORTypedefExpressoin
        XCTAssert(enumTypeDef.typeNewName == "UIControlEvents")
        let enumExp = enumTypeDef.expression as! OREnumExpressoin
        let enumFields = enumExp.fields as! [ORAssignExpression]
        XCTAssert((enumFields[0].value.value as? String) == "UIControlEventTouchDown")
        XCTAssert((enumFields[1].value.value as? String) == "UIControlEventTouchDownRepeat")
        XCTAssert((enumFields[2].value.value as? String) == "UIControlEventTouchDragInside")
        XCTAssert((enumFields[3].value.value as? String) == "UIControlEventTouchDragOutside")
        XCTAssert((enumFields[4].value.value as? String) == "UIControlEventTouchDragEnter")
        XCTAssert((enumFields[5].value.value as? String) == "UIControlEventTouchDragExit")
        XCTAssert((enumFields[6].value.value as? String) == "UIControlEventTouchUpInside")
        XCTAssert((enumFields[7].value.value as? String) == "UIControlEventTouchUpOutside")
        XCTAssert((enumFields[8].value.value as? String) == "UIControlEventTouchCancel")
        XCTAssert((enumFields[9].value.value as? String) == "UIControlEventValueChanged")
        XCTAssert((enumFields[10].value.value as? String) == "UIControlEventEditingDidBegin")
        XCTAssert((enumFields[11].value.value as? String) == "UIControlEventEditingChanged")
        XCTAssert((enumFields[12].value.value as? String) == "UIControlEventEditingDidEnd")
        XCTAssert((enumFields[13].value.value as? String) == "UIControlEventEditingDidEndOnExit")
        XCTAssert((enumFields[14].value.value as? String) == "UIControlEventAllTouchEvents")
        XCTAssert((enumFields[15].value.value as? String) == "UIControlEventAllEditingEvents")
        XCTAssert((enumFields[16].value.value as? String) == "UIControlEventApplicationReserved")
        XCTAssert((enumFields[17].value.value as? String) == "UIControlEventSystemReserved")
        XCTAssert((enumFields[18].value.value as? String) == "UIControlEventAllEvents")
        
    }
}
