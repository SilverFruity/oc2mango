//
//  InitialSymbolVisitor.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/25.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "InitialSymbolTableVisitor.h"
#import "ocSymbolTable.h"
@implementation InitialSymbolTableVisitor
- (instancetype)init
{
    self = [super init];
    symbolTableRoot = [ocSymbolTable new];
    return self;
}
- (void)visit:(nonnull ORNode *)node {
    AstVisitor_VisitNode(self, node);
}

- (void)visitAssignNode:(nonnull ORAssignNode *)node {
    
}

- (void)visitBinaryNode:(nonnull ORBinaryNode *)node {
    
}

- (void)visitBlockNode:(nonnull ORBlockNode *)node {
    for (ORNode *state in node.statements) {
        [self visit:state];
    }
}

- (void)visitBoolValue:(nonnull ORBoolValue *)node {
    
}

- (void)visitCArrayDeclNode:(nonnull ORCArrayDeclNode *)node {
    
}

- (void)visitCaseStatement:(nonnull ORCaseStatement *)node {
    
}

- (void)visitClassNode:(nonnull ORClassNode *)node {
    [symbolTableRoot increaseScope];
    
    for (ORPropertyNode *prop in node.properties) {
        // NOTE: 使用 OCIvarDecl ???
        ocDecl *ivarDecl = nil;
        ocSymbol *ivarSymbol = [ocSymbol symbolWithName:[NSString stringWithFormat:@"_%@",prop.var.var.varname] decl:ivarDecl];
        [symbolTableRoot insert:ivarSymbol];
        
        // NOTE: 使用 OCPropertyDecl ???
        ocDecl *propDecl = nil;
        ocSymbol *propSymbol = [ocSymbol symbolWithName:prop.var.var.varname decl:propDecl];
        [symbolTableRoot insert:propSymbol];
    }
    
    for (ORDeclaratorNode *ivar in node.privateVariables) {
        // NOTE: 使用 OCIvarDecl ???
        ocDecl *ivarDecl = nil;
        ocSymbol *ivarSymbol = [ocSymbol symbolWithName:[NSString stringWithFormat:@"_%@",ivar.var.varname] decl:ivarDecl];
        [symbolTableRoot insert:ivarSymbol];
    }
    
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
    ocDecl *classDecl = [ocDecl new];
    classDecl.typeName = node.className;
    classDecl.typeEncode = OCTypeStringClass;
    ocSymbol *symbol = [ocSymbol symbolWithName:node.className decl:classDecl];
    [symbolTableRoot insertRoot:symbol];
}

- (void)visitControlStatNode:(nonnull ORControlStatNode *)node {
    
}

- (void)visitDeclaratorNode:(nonnull ORDeclaratorNode *)node {
    if (node.var.varname.length <= 0) return;
//    [symbolTableRoot insert:[ocSymbol symbolWithName:node.var.varname]];
}

- (void)visitDoWhileStatement:(nonnull ORDoWhileStatement *)node {
    
}

- (void)visitDoubleValue:(nonnull ORDoubleValue *)node {
    
}

- (void)visitEmptyNode:(nonnull ORNode *)node {
    
}

- (void)visitEnumStatNode:(nonnull OREnumStatNode *)node {
    
}

- (void)visitForInStatement:(nonnull ORForInStatement *)node {
    
}

- (void)visitForStatement:(nonnull ORForStatement *)node {
    
}

- (void)visitFunctionCall:(nonnull ORFunctionCall *)node {
    
}

- (void)visitFunctionDeclNode:(nonnull ORFunctionDeclNode *)node {
    
}

- (void)visitFunctionNode:(nonnull ORFunctionNode *)node {
    [symbolTableRoot increaseScope];
    [self visit:node.scopeImp];
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
}

- (void)visitIfStatement:(nonnull ORIfStatement *)node {
    
}

- (void)visitInitDeclaratorNode:(nonnull ORInitDeclaratorNode *)node {
    
}

- (void)visitIntegerValue:(nonnull ORIntegerValue *)node {
    
}

- (void)visitMethodCall:(nonnull ORMethodCall *)node {
    
}

- (void)visitMethodDeclNode:(nonnull ORMethodDeclNode *)node {
    
}

- (void)visitMethodNode:(nonnull ORMethodNode *)node {
    [symbolTableRoot increaseScope];
    [self visit:node.scopeImp];
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
}

- (void)visitPropertyNode:(nonnull ORPropertyNode *)node {
    
}

- (void)visitProtocolNode:(nonnull ORProtocolNode *)node {
    
}

- (void)visitStructStatNode:(nonnull ORStructStatNode *)node {
    NSMutableString *typeEncode = [@"{" mutableCopy];
    [typeEncode appendString:node.sturctName];
    [typeEncode appendString:@"="];
    
    // 展开 struct 内部的符号表作用域
    [symbolTableRoot increaseScope];
    NSUInteger offset = 0;
    NSUInteger structAlignment = 8;
    for (ORDeclaratorNode *exp in node.fields) {
        NSString *typeName = exp.type.name;
        ocSymbol *symbol = [symbolTableRoot lookup:typeName];
        const char *fieldEncode = symbol ? symbol.decl.typeEncode : typeEncodeForDeclaratorNode(exp);
        [typeEncode appendFormat:@"%s",fieldEncode];
        
        //向StructNode的作用域中注册参数类型以及内存偏移量
        ocDecl * decl = [ocDecl new];
        decl.typeEncode = fieldEncode;
        decl.typeName = typeName;
        decl.offset = offset;
        ocSymbol *fieldSymbol = [ocSymbol symbolWithName:exp.var.varname decl:decl];
        [symbolTableRoot insert:fieldSymbol];
        
        // 内存对齐
        NSUInteger size = 0;
        NSGetSizeAndAlignment(fieldEncode, &size, NULL);
        size = MIN(size, structAlignment); // 在参数对齐数和默认对齐数8取小
        if (offset % size != 0) {
            offset = ((offset + size - 1) / size) * size;
        }
        
        
    }
    // 将作用域中的符号信息交给语法树节点持有
    node.scope = symbolTableRoot.scope;
    
    [symbolTableRoot decreaseScope];
    
    [typeEncode appendString:@"}"];
    
    // 根符号表注册struct
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = typeEncode.UTF8String;
    decl.typeName = node.sturctName;
    
    // 默认内存对齐值(8)时，NSGetSizeAndAlignment的值和offset的值应该相同
    assert(structAlignment == 8 && decl.size == offset);
    decl.size = offset;
    
    ocSymbol *symbol = [ocSymbol symbolWithName:node.sturctName decl:decl];
    [symbolTableRoot insertRoot:symbol];
}

- (void)visitUnionStatNode:(nonnull ORUnionStatNode *)node {
    NSMutableString *typeEncode = [@"(" mutableCopy];
    [typeEncode appendString:node.unionName];
    [typeEncode appendString:@"="];
    
    [symbolTableRoot increaseScope];
    for (ORDeclaratorNode *exp in node.fields) {
        NSString *typeName = exp.type.name;
        ocSymbol *symbol = [symbolTableRoot lookup:typeName];
        const char *fieldEncode = symbol ? symbol.decl.typeEncode : typeEncodeForDeclaratorNode(exp);
        [typeEncode appendFormat:@"%s",fieldEncode];
        
        //向Uinon的作用域中注册参数类型
        ocDecl * decl = [ocDecl new];
        decl.typeEncode = fieldEncode;
        decl.typeName = typeName;
        ocSymbol *fieldSymbol = [ocSymbol symbolWithName:exp.var.varname decl:decl];
        [symbolTableRoot insert:fieldSymbol];
    }
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
    
    [typeEncode appendString:@")"];
    // 根符号表注册union
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = typeEncode.UTF8String;
    decl.typeName = node.unionName;
    ocSymbol *symbol = [ocSymbol symbolWithName:node.unionName decl:decl];
    [symbolTableRoot insertRoot:symbol];

}

- (void)visitSubscriptNode:(nonnull ORSubscriptNode *)node {
    
}

- (void)visitSwitchStatement:(nonnull ORSwitchStatement *)node {
    
}

- (void)visitTernaryNode:(nonnull ORTernaryNode *)node {
    
}

- (void)visitTypeNode:(nonnull ORTypeNode *)node {
    
}

- (void)visitTypedefStatNode:(nonnull ORTypedefStatNode *)node {
    
}

- (void)visitUIntegerValue:(nonnull ORUIntegerValue *)node {
    
}

- (void)visitUnaryNode:(nonnull ORUnaryNode *)node {
    
}



- (void)visitValueNode:(nonnull ORValueNode *)node {
    
}

- (void)visitVariableNode:(nonnull ORVariableNode *)node {
    
}

- (void)visitWhileStatement:(nonnull ORWhileStatement *)node {
    
}

@end
