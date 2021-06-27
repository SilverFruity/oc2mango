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
    symbol = ((ORNode *)ast.nodes.lastObject).scope[AnonymousBlockSignature];
    XCTAssert(strcmp(symbol.decl.typeEncode?:"", "@?dii") == 0);
    
}
- (void)testExample {
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

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
