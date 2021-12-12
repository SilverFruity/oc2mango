//
//  SymbolParser.m
//  SymbolTableTests
//
//  Created by Jiang on 2021/12/12.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "SymbolParser.h"

@implementation SymbolParser
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.visitor = [SymbolTableVisitor new];
    }
    return self;
}
- (AST *)parseCodeSource:(CodeSource *)source{
    symbolTableRoot = [ocSymbolTable new];
    AST *ast = [super parseCodeSource:source];
    NSAssert(self.error == nil, @"%@",self.error);
    for (ORNode *node in ast.nodes) {
        [self.visitor visit:node];
    }
    ast.scope = symbolTableRoot.scope;
    return ast;
}

@end
