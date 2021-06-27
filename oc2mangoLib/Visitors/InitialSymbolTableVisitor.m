//
//  InitialSymbolVisitor.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/25.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "InitialSymbolTableVisitor.h"

NSString *AnonymousBlockSignature = @"BlockSignature";

static const char *typeEncodeForDeclaratorNode(ORDeclaratorNode * node);
static const char *typeEncodeWithSearchSymbolTable(ORDeclaratorNode *node){
    ORTypeNode *typeSpecial = node.type;
    ORVariableNode *var = node.var;
    OCType type = typeSpecial.type;
    ocSymbol *symbol = [symbolTableRoot lookup:typeSpecial.name];
    char encoding[128] = { 0 };
    const char *suffixEncode = "";
    if (symbol) {
        suffixEncode = symbol.decl.typeEncode;
        assert(suffixEncode != NULL);
        type = symbol.decl.type;
    }else{
        #define CaseTypeEncoding(type)\
        case OCType##type: suffixEncode = OCTypeString##type; break;
        switch (type) {
            case OCTypeChar:
            {
                if (var.ptCount > 0)
                    strcat(encoding, OCTypeStringCString);
                else
                    strcat(encoding, OCTypeStringChar);
                break;
            }
                CaseTypeEncoding(Int)
                CaseTypeEncoding(Short)
                CaseTypeEncoding(Long)
                CaseTypeEncoding(LongLong)
                CaseTypeEncoding(UChar)
                CaseTypeEncoding(UInt)
                CaseTypeEncoding(UShort)
                CaseTypeEncoding(ULong)
                CaseTypeEncoding(ULongLong)
                CaseTypeEncoding(Float)
                CaseTypeEncoding(Double)
                CaseTypeEncoding(BOOL)
                CaseTypeEncoding(Object)
                CaseTypeEncoding(Class)
                CaseTypeEncoding(SEL)
            default:
                break;
        }
        #undef CaseTypeEncoding
    }
    NSInteger tmpPtCount = var.ptCount;
    if (tmpPtCount == 0) {
        char typeEncode[2] = { type, '\0' };
        return strdup(typeEncode);
    }
    while (tmpPtCount > 0) {
        if (type == OCTypeChar && tmpPtCount == 1) {
            break;
        }
        strcat(encoding, "^");
        tmpPtCount--;
    }
    strcat(encoding, suffixEncode);
    strcat(encoding, "\0");
    return [NSString stringWithFormat:@"%s",encoding].UTF8String;
}

static const char *cArrayTypeEncode(ORCArrayDeclNode *node){
    // for xx a[];
    if ([(ORIntegerValue *)node.capacity value] == 0) {
        const char *result = typeEncodeWithSearchSymbolTable(node);
        size_t result_len = strlen(result);
        size_t buffer_len = result_len + 2;
        char buffer[buffer_len];
        memset(buffer, 0, buffer_len);
        buffer[0] = '^';
        memcpy(buffer + 1, result, result_len);
        return [NSString stringWithFormat:@"%s",buffer].UTF8String;;
    }
    ORCArrayDeclNode *tmp = node;
    NSMutableArray *nodes = [NSMutableArray array];
    while (tmp) {
        [nodes insertObject:tmp atIndex:0];
        tmp = tmp.prev;
    }
    char result[100] = {0};
    char buffer[50]  = {0};
    char rights[20]  = {0};
    for (int i = 0; i < nodes.count; i++) {
        ORCArrayDeclNode *item = nodes[i];
        sprintf(buffer, "[%lld", [(ORIntegerValue *)item.capacity value]);
        strcat(result, buffer);
        if (i != nodes.count - 1) {
            strcat(rights, "]");
        }else{
            sprintf(buffer, "%s]", ""); //typeEncode(typeSpecial, nil));
            strcat(result, buffer);
        }
    }
    strcat(result, rights);
    return [NSString stringWithFormat:@"%s",result].UTF8String;
}
static const char *functionTypeEncode(ORFunctionDeclNode *node){
    char signature [128] = { 0 };
    // 函数 void (int, int) TypEncode 签名: ^?vii
    // Block void (^)(int, int) TypEncode 签名: @?v@ii
    
    ORDeclaratorNode *returnNode = [ORDeclaratorNode copyFromDecl:node];
    if(node.var.isBlock){
        // block
        strcat(signature, "@?");
    }else{
        // function
        // 针对 void func(void); 其ptCount默认为1，当作函数指针处理
        // ？paser.y中直接默认为1的可行性
        strcat(signature, "^?");
    }
    strcat(signature, typeEncodeForDeclaratorNode(returnNode));
    for (ORDeclaratorNode *param in node.params) {
        strcat(signature, typeEncodeForDeclaratorNode(param));
    }
    return [NSString stringWithFormat:@"%s",signature].UTF8String;;
}

static const char *typeEncodeForDeclaratorNode(ORDeclaratorNode * node){
    if (node.nodeType == AstEnumCArrayDeclNode){
        ORCArrayDeclNode *arrayNode = (ORCArrayDeclNode *)node;
        return cArrayTypeEncode(arrayNode);
    }else if (node.nodeType == AstEnumFunctionDeclNode){
        ORFunctionDeclNode *functionNode = (ORFunctionDeclNode *)node;
        return functionTypeEncode(functionNode);
    }
    return typeEncodeWithSearchSymbolTable(node);
}

@implementation InitialSymbolTableVisitor
- (instancetype)init
{
    self = [super init];
    symbolTableRoot = [ocSymbolTable new];
    NSLog(@"%@",symbolTableRoot);
    return self;
}
- (void)visit:(nonnull ORNode *)node {
    AstVisitor_VisitNode(self, node);
}

#pragma mark - Function
- (void)visitBlockNode:(nonnull ORBlockNode *)node {
    for (ORNode *state in node.statements) {
        [self visit:state];
    }
}
- (void)visitFunctionDeclNode:(nonnull ORFunctionDeclNode *)node {
    const char *signature = typeEncodeForDeclaratorNode(node);
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = signature;
    // Return Type Name，使用函数的返回值信息，作为函数的符号类型
    decl.typeName = node.type.name;
    NSAssert(node.var.varname.length > 0, @"");
    // 针对正常的函数实现，在函数作用域的上一级作用域注册该函数的信息
    ocSymbol *symbol = [ocSymbol symbolWithName:node.var.varname decl:decl];
    [symbolTableRoot insert:symbol];
}

- (void)visitFunctionNode:(nonnull ORFunctionNode *)node {
    
    const char *signature = typeEncodeForDeclaratorNode(node.declare);
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = signature;
    // Return Type Name，使用函数的返回值信息，作为函数的符号类型
    decl.typeName = node.declare.type.name;
    NSString *functionName = node.declare.var.varname;
    
    // 针对正常的函数实现，在函数作用域的上一级作用域注册该函数的信息
    if (functionName.length != 0){
        ocSymbol *symbol = [ocSymbol symbolWithName:functionName decl:decl];
        [symbolTableRoot insert:symbol];
    }
    
    [symbolTableRoot increaseScope];
    
    //针对匿名函数，需要自己在自己的作用域中持有签名信息
    //形如: ^(int a, int b){  }
    if (functionName.length == 0){
        ocSymbol *symbol = [ocSymbol symbolWithName:AnonymousBlockSignature decl:decl];
        [symbolTableRoot insert:symbol];
    }
    
    // 在函数实现的作用域中添加参数的符号信息
    for (ORNode *param in node.declare.params) {
        [self visit:param];
    }
    [self visit:node.scopeImp];
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
}

#pragma mark - Class
- (void)visitMethodNode:(nonnull ORMethodNode *)node {
    [symbolTableRoot increaseScope];
    [self visit:node.declare];
    [self visit:node.scopeImp];
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
}

- (void)visitPropertyNode:(nonnull ORPropertyNode *)node {
    ocDecl *ivarDecl = [ocDecl new];
    ivarDecl.typeEncode = typeEncodeForDeclaratorNode(node.var);
    ivarDecl.typeName = node.var.type.name;
    ocSymbol *ivarSymbol = [ocSymbol symbolWithName:[NSString stringWithFormat:@"_%@",node.var.var.varname] decl:ivarDecl];
    [symbolTableRoot insert:ivarSymbol];
//    NOTE: 使用 OCPropertyDecl ???, property相关的的符号表应该存储在哪里？
//    ocDecl *propDecl = nil;
//    ocSymbol *propSymbol = [ocSymbol symbolWithName:node.var.var.varname decl:propDecl];
//    [symbolTableRoot insert:propSymbol];
}
- (void)visitProtocolNode:(nonnull ORProtocolNode *)node {

}
- (void)visitMethodDeclNode:(nonnull ORMethodDeclNode *)node {
    for (int i = 0; i < node.parameterNames.count; i++) {
        NSString *name = node.parameterNames[i];
        ORDeclaratorNode *declNode = node.parameterTypes[i];
        declNode.var.varname = name;
        [self visit:declNode];
    }
}
- (void)visitClassNode:(nonnull ORClassNode *)node {
    [symbolTableRoot increaseScope];
    for (ORPropertyNode *prop in node.properties) {
        [self visit:prop];
    }
    for (ORDeclaratorNode *ivar in node.privateVariables) {
        [self visit:ivar];
    }
    // 所有 method 的父作用域是 Class 作用域
    for (ORMethodNode *method in node.methods) {
        [self visitMethodNode:method];
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

#pragma mark - ConstValue
- (void)visitValueNode:(nonnull ORValueNode *)node {
    
}
- (void)visitBoolValue:(nonnull ORBoolValue *)node {
    
}
- (void)visitIntegerValue:(nonnull ORIntegerValue *)node {
    
}
- (void)visitUIntegerValue:(nonnull ORUIntegerValue *)node {
    
}
- (void)visitDoubleValue:(nonnull ORDoubleValue *)node {
    
}
- (void)visitEmptyNode:(nonnull ORNode *)node {
    
}
#pragma mark - Control Flow
- (void)visitIfStatement:(nonnull ORIfStatement *)node {
    while (node) {
        if (!node.condition) {
            [self visit:node.scopeImp];
        }else{
            [self visit:node.condition];
            [self visit:node.scopeImp];
        }
        node = node.last;
    }
}
- (void)visitWhileStatement:(nonnull ORWhileStatement *)node {
    [symbolTableRoot increaseScope];
    [self visit:node.condition];
    [self visit:node.scopeImp];
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
}

- (void)visitDoWhileStatement:(nonnull ORDoWhileStatement *)node {
    [symbolTableRoot increaseScope];
    [self visit:node.scopeImp];
    [self visit:node.condition];
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
}

- (void)visitForStatement:(nonnull ORForStatement *)node {
    [symbolTableRoot increaseScope];
    for (ORNode *exp in node.expressions) {
        [self visit:exp];
    }
    [self visit:node.condition];
    [self visit:node.scopeImp];
    [symbolTableRoot decreaseScope];
}

- (void)visitForInStatement:(nonnull ORForInStatement *)node {
    [symbolTableRoot increaseScope];
    [self visit:node.expression];
    [self visit:node.value];
    [self visit:node.scopeImp];
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
}

- (void)visitSwitchStatement:(nonnull ORSwitchStatement *)node {
    [self visit:node.value];
    for (ORNode *caseState in node.cases) {
        [self visit:caseState];
    }
}

- (void)visitCaseStatement:(nonnull ORCaseStatement *)node {
    [symbolTableRoot increaseScope];
    [self visit:node.scopeImp];
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
}
#pragma mark -  Major New Symbols
- (void)visitDeclaratorNode:(nonnull ORDeclaratorNode *)node {
    ocDecl *decl = [ocDecl new];
    decl.typeName = node.type.name;
    decl.typeEncode = typeEncodeForDeclaratorNode(node);
    ocSymbol * symbol = [ocSymbol symbolWithName:node.var.varname decl:decl];
    [symbolTableRoot insert:symbol];
}

- (void)visitInitDeclaratorNode:(nonnull ORInitDeclaratorNode *)node {
    [self visit:node.declarator];
    [self visit:node.expression];
}
NSUInteger momeryLayoutAlignment(NSUInteger offset, NSUInteger size, NSUInteger align){
    size = MIN(size, align); // 在参数对齐数和默认对齐数取小
    if (offset % size != 0) {
        offset = ((offset + size - 1) / size) * size;
    }
    return offset;
}
- (void)visitStructStatNode:(nonnull ORStructStatNode *)node {
    // 展开 struct 内部的符号表作用域
    [symbolTableRoot increaseScope];
    
    NSMutableString *typeEncode = [@"{" mutableCopy];
    [typeEncode appendString:node.sturctName];
    [typeEncode appendString:@"="];
    NSUInteger structAlignment = 8;
    ocDecl *lastDecl = nil;
    for (ORDeclaratorNode *exp in node.fields) {
        NSString *typeName = exp.type.name;
        ocSymbol *symbol = [symbolTableRoot lookup:typeName];
        const char *fieldEncode = symbol ? symbol.decl.typeEncode : typeEncodeForDeclaratorNode(exp);
        [typeEncode appendFormat:@"%s",fieldEncode];
        
        //向StructNode的作用域中注册参数类型以及内存偏移量
        ocDecl * decl = [ocDecl new];
        decl.typeEncode = fieldEncode;
        decl.typeName = typeName;
        // 内存对齐
        decl.offset = momeryLayoutAlignment(lastDecl.offset + lastDecl.size, decl.size, structAlignment);;
        lastDecl = decl;
        ocSymbol *fieldSymbol = [ocSymbol symbolWithName:exp.var.varname decl:decl];
        [symbolTableRoot insert:fieldSymbol];
    }
    NSUInteger offset = momeryLayoutAlignment(lastDecl.offset + lastDecl.size, structAlignment, structAlignment);
    [typeEncode appendString:@"}"];
    // 根符号表注册struct
    ocComposeDecl *decl = [ocComposeDecl new];
    decl.typeEncode = typeEncode.UTF8String;
    decl.typeName = node.sturctName;
    // 将作用域中的符号信息交给struct的字段符号表持有
    decl.fielsScope = symbolTableRoot.scope;
    // 默认内存对齐值(8)时，NSGetSizeAndAlignment的值和offset的值应该相同
    assert(structAlignment == 8 && decl.size == offset);
    decl.size = offset;
    ocSymbol *symbol = [ocSymbol symbolWithName:node.sturctName decl:decl];
    [symbolTableRoot insertRoot:symbol];
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
}

- (void)visitUnionStatNode:(nonnull ORUnionStatNode *)node {
    [symbolTableRoot increaseScope];
    
    NSMutableString *typeEncode = [@"(" mutableCopy];
    [typeEncode appendString:node.unionName];
    [typeEncode appendString:@"="];
    
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
    [typeEncode appendString:@")"];
    
    // 根符号表注册union
    ocComposeDecl *decl = [ocComposeDecl new];
    decl.typeEncode = typeEncode.UTF8String;
    decl.typeName = node.unionName;
    decl.fielsScope = symbolTableRoot.scope;
    ocSymbol *symbol = [ocSymbol symbolWithName:node.unionName decl:decl];
    [symbolTableRoot insertRoot:symbol];
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
}
- (void)visitEnumStatNode:(nonnull OREnumStatNode *)node {
    ocDecl *decl = [ocDecl new];
    char type = node.valueType;
    decl.typeEncode = &type;
    decl.typeName = node.enumName;
    ocSymbol *symbol = [ocSymbol symbolWithName:node.enumName decl:decl];
    [symbolTableRoot insertRoot:symbol];
    for (ORNode *exp in node.fields) {
        if (exp.nodeType == AstEnumAssignNode) {
            ORAssignNode *assignExp = (ORAssignNode *)exp;
            [symbolTableRoot insertRootWithName:[(ORValueNode *)assignExp.expression value] symbol:symbol];
        }else if (exp.nodeType == AstEnumValueNode){
            [symbolTableRoot insertRootWithName:[(ORValueNode *)exp value] symbol:symbol];
        }
    }
}
- (void)visitTypedefStatNode:(nonnull ORTypedefStatNode *)node {
    switch (node.nodeType) {
        case AstEnumDeclaratorNode:
        case AstEnumFunctionDeclNode:
        case AstEnumCArrayDeclNode:
        {
            ORDeclaratorNode *declarator = (ORDeclaratorNode *)node.expression;
            [self visit:declarator];
            ocSymbol *symbol = [symbolTableRoot lookup:declarator.var.varname];
            [symbolTableRoot insertRootWithName:node.typeNewName symbol:symbol];
            break;
        }
        case AstEnumStructStatNode:
        {
            ORStructStatNode *structNode = (ORStructStatNode *)node;
            [self visit:structNode];
            ocSymbol *symbol = [symbolTableRoot lookup:structNode.sturctName];
            [symbolTableRoot insertRootWithName:node.typeNewName symbol:symbol];
            break;
        }
        case AstEnumEnumStatNode:
        {
            OREnumStatNode *enumNode = (OREnumStatNode *)node;
            [self visit:enumNode];
            ocSymbol *symbol = [symbolTableRoot lookup:enumNode.enumName];
            [symbolTableRoot insertRootWithName:node.typeNewName symbol:symbol];
            break;
        }
        case AstEnumUnionStatNode:
        {
            ORUnionStatNode *unionNode = (ORUnionStatNode *)node.expression;
            [self visit:unionNode];
            ocSymbol *symbol = [symbolTableRoot lookup:unionNode.unionName];
            [symbolTableRoot insertRootWithName:node.typeNewName symbol:symbol];
            break;
        }
        default:
            break;
    }
}

- (void)visitCArrayDeclNode:(nonnull ORCArrayDeclNode *)node {
    
}


#pragma mark - Operation Exp
- (void)visitFunctionCall:(nonnull ORFunctionCall *)node {
    
}

- (void)visitMethodCall:(nonnull ORMethodCall *)node {
    
}

- (void)visitTypeNode:(nonnull ORTypeNode *)node {
    
}

- (void)visitVariableNode:(nonnull ORVariableNode *)node {
    
}

- (void)visitAssignNode:(nonnull ORAssignNode *)node {
    
}

- (void)visitBinaryNode:(nonnull ORBinaryNode *)node {
    
}

- (void)visitSubscriptNode:(nonnull ORSubscriptNode *)node {
    
}

- (void)visitTernaryNode:(nonnull ORTernaryNode *)node {
    
}
- (void)visitUnaryNode:(nonnull ORUnaryNode *)node {
    
}



@end
