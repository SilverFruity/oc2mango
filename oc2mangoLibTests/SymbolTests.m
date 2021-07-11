//
//  SymbolTests.m
//  oc2mangoLibTests
//
//  Created by Jiang on 2021/6/27.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <oc2mangoLib/oc2mangoLib.h>
@interface SymbolParser: Parser
@property (nonatomic, strong)InitialSymbolTableVisitor *visitor;
@end

@implementation SymbolParser
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.visitor = [InitialSymbolTableVisitor new];
    }
    return self;
}
- (AST *)parseCodeSource:(CodeSource *)source{
    AST *ast = [super parseCodeSource:source];
    NSAssert(self.error == nil, @"%@",self.error);
    symbolTableRoot = [ocSymbolTable new];
    for (ORNode *node in ast.nodes) {
        [self.visitor visit:node];
    }
    ast.scope = symbolTableRoot.scope;
    return ast;
}

@end
@interface SymbolTests : XCTestCase
{
    NSString *source;
    SymbolParser *parser;
}
@end

@implementation SymbolTests

- (void)setUp {
    parser = [SymbolParser new];
}

- (void)tearDown {
    parser = nil;
}
struct ORPoint{
    double x;
    int y;
    double z;
};
- (void)testStruct{
    source = @"\
    struct ORPoint{\
      double x;\
      int y;\
      double z;\
    };\
    ";
    AST *ast = [parser parseSource:source];
    ocSymbol *symbol = ast.scope[@"ORPoint"];
    XCTAssert([symbol.decl isStruct]);
    XCTAssert(strcmp(symbol.decl.typeEncode, @encode(struct ORPoint)) == 0);
    ocScope *structScope = ((ORNode *)ast.nodes.lastObject).scope;
    ocDecl *decl = structScope[@"x"].decl;
    XCTAssert(decl.offset == 0);
    XCTAssert(decl.size == 8);
    XCTAssert(decl.type == OCTypeDouble);
    decl = structScope[@"y"].decl;
    XCTAssert(decl.offset == 8);
    XCTAssert(decl.size == 4);
    XCTAssert(decl.type == OCTypeInt);
    decl = structScope[@"z"].decl;
    XCTAssert(decl.offset == 16);
    XCTAssert(decl.size == 8);
    XCTAssert(decl.type == OCTypeDouble);
    
}
union ORValue{
    char x;
    short y;
    int z;
};
- (void)testUnion{
    source = @" \
    union ORValue{\
        char x;\
        short y;\
        int z;\
    };"
    ;
    AST *ast = [parser parseSource:source];
    ocSymbol *symbol = ast.scope[@"ORValue"];
    XCTAssert([symbol.decl isUnion]);
    XCTAssert(strcmp(symbol.decl.typeEncode, @encode(union ORValue)) == 0);
    ocScope *unionScope = ((ORNode *)ast.nodes.lastObject).scope;
    ocDecl *decl = unionScope[@"x"].decl;
    XCTAssert(decl.offset == 0);
    XCTAssert(decl.size == 1);
    XCTAssert(decl.type == OCTypeChar);
    decl = unionScope[@"y"].decl;
    XCTAssert(decl.offset == 0);
    XCTAssert(decl.size == 2);
    XCTAssert(decl.type == OCTypeShort);
    decl = unionScope[@"z"].decl;
    XCTAssert(decl.offset == 0);
    XCTAssert(decl.size == 4);
    XCTAssert(decl.type == OCTypeInt);
}
- (void)testFunction{
    source = @"\
    double func1(int a, int b);\
    double (*func2)(int a, int b);\
    double (^block)(int a, int b);\
    double funcImp(int a, int b){  }\
    ^double (int a, int b){\
    };\
    ";
    AST *ast = [parser parseSource:source];
    ocSymbol *symbol = ast.scope[@"func1"];
    XCTAssert(strcmp(symbol.decl.typeEncode?:"", "^?dii") == 0);
    symbol = ast.scope[@"func2"];
    XCTAssert(strcmp(symbol.decl.typeEncode?:"", "^?dii") == 0);
    symbol = ast.scope[@"block"];
    XCTAssert(strcmp(symbol.decl.typeEncode?:"", "@?dii") == 0);
    symbol = ast.scope[@"funcImp"];
    XCTAssert(strcmp(symbol.decl.typeEncode?:"", "^?dii") == 0);
    symbol = ((ORNode *)ast.nodes.lastObject).symbol;
    XCTAssert(strcmp(symbol.decl.typeEncode?:"", "@?dii") == 0);
    
}
- (void)testSimpleDeclarator{
    source = @"int a; double b;";
    AST *ast = [parser parseSource:source];
    ocSymbol *symbol = ast.scope[@"a"];
    XCTAssert(strcmp(symbol.decl.typeEncode, OCTypeStringInt) == 0);
    XCTAssert(symbol.decl.type == OCTypeInt);
    
    symbol = ast.scope[@"b"];
    XCTAssert(strcmp(symbol.decl.typeEncode, OCTypeStringDouble) == 0);
    XCTAssert(symbol.decl.type == OCTypeDouble);
    
//    ast.scope[@"b"];
}
- (void)testClass{
    source = @" \
    @interface TestClass: NSObject\
    @property(nonatomic, strong)id object;\
    @property(nonatomic, strong)NSString *string;\
    @property(nonatomic, strong)NSArray *array;\
    @end\
    @implementation TestClass\
    {\
        int a;\
        double b;\
        NSString *c;\
        void *d;\
    }\
    - (instancetype)initWithObject:(id)object{  }\
    + (instranceType)objectWithA:(int)a b:(double)b c:(NSString *)c d:(void **)d{ }\
    @end";
    AST *ast = [parser parseSource:source];
    ORClassNode *classNode = ast.nodes.firstObject;
    ocSymbol *symbol = classNode.scope[@"_object"];
    XCTAssert([symbol.decl.typeName isEqualToString:@"id"], @"%@",symbol.decl.typeName);
    XCTAssert(symbol.decl.type = OCTypeObject);
    XCTAssert(symbol.decl.isIvar);
    
    symbol = classNode.scope[@"@object"];
    XCTAssert([symbol.decl.typeName isEqualToString:@"id"], @"%@",symbol.decl.typeName);
    XCTAssert(symbol.decl.type = OCTypeObject);
    XCTAssert(symbol.decl.isProperty);
    XCTAssert(symbol.decl.propModifer && (MFPropertyModifierNonatomic | MFPropertyModifierMemStrong));
    
    symbol = classNode.scope[@"_string"];
    XCTAssert([symbol.decl.typeName isEqualToString:@"NSString"], @"%@",symbol.decl.typeName);
    XCTAssert(symbol.decl.type = OCTypeObject);
    XCTAssert(strcmp(symbol.decl.typeEncode, "@") == 0);
    XCTAssert(symbol.decl.isIvar);
    
    symbol = classNode.scope[@"@string"];
    XCTAssert([symbol.decl.typeName isEqualToString:@"NSString"], @"%@",symbol.decl.typeName);
    XCTAssert(symbol.decl.type = OCTypeObject);
    XCTAssert(symbol.decl.isProperty);
    XCTAssert(symbol.decl.propModifer && (MFPropertyModifierNonatomic | MFPropertyModifierMemStrong));
    
    symbol = classNode.scope[@"a"];
    XCTAssert(symbol.decl.type = OCTypeInt);
    XCTAssert(symbol.decl.isIvar);
    
    symbol = classNode.scope[@"b"];
    XCTAssert(symbol.decl.type = OCTypeDouble);
    XCTAssert(symbol.decl.isIvar);
    
    symbol = classNode.scope[@"d"];
    XCTAssert(symbol.decl.type = OCTypePointer);
    XCTAssert(symbol.decl.isIvar);
    
    symbol = classNode.scope[@"initWithObject:"];
    XCTAssert(strcmp(symbol.decl.typeEncode, "@@:@") == 0, @"%s",symbol.decl.typeEncode);
    XCTAssert(symbol.decl.type = OCTypeObject);
    XCTAssert(symbol.decl.isMethod);
    XCTAssert(symbol.decl.isClassMethod == NO);
    
    symbol = classNode.scope[@"objectWithA:b:c:d:"];
    XCTAssert(strcmp(symbol.decl.typeEncode, "@@:id@^^v") == 0, @"%s",symbol.decl.typeEncode);
    XCTAssert(symbol.decl.type = OCTypeObject);
    XCTAssert(symbol.decl.isMethod);
    XCTAssert(symbol.decl.isClassMethod);
    
    ORMethodNode *method = classNode.methods[0];
    symbol = method.scope[@"object"];
    XCTAssert(symbol.decl.type = OCTypeObject);
    XCTAssert([symbol.decl.typeName isEqualToString:@"id"], @"%@",symbol.decl.typeName);
    
    method = classNode.methods[1];
    symbol = method.scope[@"a"];
    XCTAssert(strcmp(symbol.decl.typeEncode, "i") == 0);
    symbol = method.scope[@"b"];
    XCTAssert(strcmp(symbol.decl.typeEncode, "d") == 0);
    symbol = method.scope[@"c"];
    XCTAssert(strcmp(symbol.decl.typeEncode, "@") == 0);
    symbol = method.scope[@"d"];
    XCTAssert(strcmp(symbol.decl.typeEncode, "^^v") == 0, @"%s", symbol.decl.typeEncode);
    
}
- (void)testClassDetect{
    source = @" \
    @interface TestClass: NSObject\
    @property(nonatomic, strong)id object;\
    @property(nonatomic, strong)NSString *string;\
    @property(nonatomic, strong)NSArray *array;\
    @end\
    @implementation TestClass\
    @end\
    void function(){\
        NSMutableArray *a;\
        [a addObject:@\"123\"];\
        NSSimulatorClass *b;\
        b.block();\
        NSSimulatorClass1 *c;\
        c.value = 1;\
        NSSimulatorClass2 *d;\
        int a = d.value;\
        [NSSimulatorClass3 new];\
    }\
    ";
    AST *ast = [parser parseSource:source];
    ocSymbol *symbol = ast.scope[@"NSString"];
    XCTAssert(symbol.decl.type == OCTypeObject);
    XCTAssert(symbol.decl.isClassRef);
    symbol = ast.scope[@"NSArray"];
    XCTAssert(symbol.decl.type == OCTypeObject);
    XCTAssert(symbol.decl.isClassRef);
    symbol = ast.scope[@"NSSimulatorClass"];
    XCTAssert(symbol.decl.type == OCTypeObject);
    XCTAssert(symbol.decl.isClassRef);
    symbol = ast.scope[@"NSSimulatorClass1"];
    XCTAssert(symbol.decl.type == OCTypeObject);
    XCTAssert(symbol.decl.isClassRef);
    symbol = ast.scope[@"NSSimulatorClass2"];
    XCTAssert(symbol.decl.type == OCTypeObject);
    XCTAssert(symbol.decl.isClassRef);
    symbol = ast.scope[@"NSSimulatorClass3"];
    XCTAssert(symbol.decl.type == OCTypeObject);
    XCTAssert(symbol.decl.isClassRef);
}
- (void)testCArraySymbol{
    source = @" \
    int* a[10][100];\
    int* b[c][d];\
    ";
    AST *ast = [parser parseSource:source];
    ocSymbol *symbol = ast.scope[@"a"];
    XCTAssert(strcmp(symbol.decl.typeEncode, @encode(int* [10][100])) == 0);
    symbol = ast.scope[@"b"];
    XCTAssert(strcmp(symbol.decl.typeEncode, "[%ld[%ld^i]]") == 0);
    
}
- (void)testStructFieldGet{
    source = @"\
    struct ORPoint{\
      double x;\
      int y;\
      double z;\
    };\
    ORPoint point;\
    point.x = 1.0;\
    ";
    AST *ast = [parser parseSource:source];
    ORMethodCall *call = ast.globalStatements.lastObject;
}
- (void)testStringConstant{
    source = @"\
    @\"123\"; \
    @\"1234\"; \
    @\"123\"; \
    ";
    AST *ast = [parser parseSource:source];
    ORValueNode *node1 = ast.nodes[0];
    void *buffer1 = symbolTableRoot->constants + node1.symbol.decl.offset;
    XCTAssert([[NSString stringWithUTF8String:buffer1] isEqualToString:@"123"]);
    ORValueNode *node2 = ast.nodes[1];
    void *buffer2 = symbolTableRoot->constants + node2.symbol.decl.offset;
    XCTAssert([[NSString stringWithUTF8String:buffer2] isEqualToString:@"1234"]);
    ORValueNode *node3 = ast.nodes[2];
    XCTAssert(node1.symbol.decl.offset == node3.symbol.decl.offset);
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
