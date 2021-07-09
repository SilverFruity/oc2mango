//
//  InitialSymbolVisitor.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/25.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "InitialSymbolTableVisitor.h"
#import "ocHandleTypeEncode.h"

NSString *AnonymousBlockSignature = @"BlockSignature";
static unsigned long or_mem_offset = 0;
static unsigned long or_const_offset = 0;

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
                CaseTypeEncoding(Void)
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
        if (type == OCTypeObject && tmpPtCount == 1) {
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
        if (item.capacity.isConst) {
            sprintf(buffer, "[%ld", [item.capacity integerValue]);
        }else if(item.capacity){
            memset(buffer, 0, strlen(buffer));
            strcpy(buffer, "[%ld");
        }
        strcat(result, buffer);
        if (i != nodes.count - 1) {
            strcat(rights, "]");
        }else{
            sprintf(buffer, "%s]", typeEncodeForDeclaratorNode([ORDeclaratorNode copyFromDecl:item]));
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
    or_mem_offset = 0;
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
    or_mem_offset = 0;
}

#pragma mark - Class

- (void)visitProtocolNode:(nonnull ORProtocolNode *)node {

}
- (void)visitPropertyNode:(nonnull ORPropertyNode *)node {
    ocDecl *propDecl = [ocDecl new];
    propDecl.typeEncode = typeEncodeForDeclaratorNode(node.var);
    propDecl.typeName = node.var.type.name;
    propDecl->isProperty = YES;
    propDecl.propModifer = node.modifier;
    ocSymbol *propSymbol = [ocSymbol symbolWithName:[NSString stringWithFormat:@"@%@",node.var.var.varname] decl:propDecl];
    [symbolTableRoot insert:propSymbol];
    
    // 不使用assing的类型可以确定为NSObject的子类，向根符号表注册类符号
    MFPropertyModifier modifer = propDecl.propModifer & MFPropertyModifierMemMask;
    if (modifer != MFPropertyModifierMemAssign) {
        ocDecl *classDecl = [ocDecl new];
        classDecl.typeName = node.var.type.name;
        classDecl.typeEncode = OCTypeStringObject;
        classDecl->isClassRef = YES;
        ocSymbol *symbol = [ocSymbol symbolWithName:classDecl.typeName decl:classDecl];
        [symbolTableRoot insertRoot:symbol];
    }
    
    ocDecl *ivarDecl = [ocDecl new];
    ivarDecl.typeEncode = propDecl.typeEncode;
    ivarDecl.typeName = propDecl.typeName;
    ivarDecl->isIvar = YES;
    ocSymbol *ivarSymbol = [ocSymbol symbolWithName:[NSString stringWithFormat:@"_%@",node.var.var.varname] decl:ivarDecl];
    [symbolTableRoot insert:ivarSymbol];
}
- (void)visitMethodDeclNode:(nonnull ORMethodDeclNode *)node {
    //向method作用域注册参数符号
    for (int i = 0; i < node.parameters.count; i++) {
        [self visit:node.parameters[i]];
    }
}
- (void)visitMethodNode:(nonnull ORMethodNode *)node {
    
    or_mem_offset = 0;
    
    //生成 method 签名信息
    char methodTypeEncode[256] = { 0 };
    const char *returnTypeEncode = typeEncodeForDeclaratorNode(node.declare.returnType);
    strcat(methodTypeEncode, returnTypeEncode);
    strcat(methodTypeEncode, OCTypeStringObject);
    strcat(methodTypeEncode, OCTypeStringSEL);
    for (ORDeclaratorNode *param in node.declare.parameters) {
        strcat(methodTypeEncode, typeEncodeForDeclaratorNode(param));
    }
    
    ocDecl *methodDecl = [ocDecl new];
    methodDecl.typeEncode = methodTypeEncode;
    methodDecl.size = sizeOfTypeEncode(returnTypeEncode);
    methodDecl->isMethod = YES;
    methodDecl->isClassMethod = node.declare.isClassMethod;
    
    //向Class作用域添加Method的符号信息
    ocSymbol *symbol = [ocSymbol new];
    symbol.decl = methodDecl;
    symbol.name = node.declare.selectorName;
    [symbolTableRoot insert:symbol];
    
    [symbolTableRoot increaseScope];
    [self visit:node.declare];
    [self visit:node.scopeImp];
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
    
    or_mem_offset = 0;
}

- (void)visitClassNode:(nonnull ORClassNode *)node {
    ocDecl *classDecl = [ocDecl new];
    classDecl.typeName = node.className;
    classDecl.typeEncode = OCTypeStringObject;
    ocSymbol *symbol = [ocSymbol symbolWithName:node.className decl:classDecl];
    [symbolTableRoot insertRoot:symbol];
    
    [symbolTableRoot increaseScope];
    for (ORPropertyNode *prop in node.properties) {
        [self visit:prop];
    }
    for (ORDeclaratorNode *ivar in node.privateVariables) {
        ocDecl *ivarDecl = [ocDecl new];
        ivarDecl.typeEncode = typeEncodeForDeclaratorNode(ivar);
        ivarDecl.typeName = ivar.type.name;
        ivarDecl->isIvar = YES;
        ocSymbol *ivarSymbol = [ocSymbol symbolWithName:ivar.var.varname decl:ivarDecl];
        [symbolTableRoot insert:ivarSymbol];
    }
    // 所有 method 的父作用域是 Class 作用域
    for (ORMethodNode *method in node.methods) {
        [self visitMethodNode:method];
    }
    node.scope = symbolTableRoot.scope;
    [symbolTableRoot decreaseScope];
    
}

- (void)visitControlStatNode:(nonnull ORControlStatNode *)node {
    [self visit:node.expression];
}

#pragma mark - ConstValue
- (void)visitValueNode:(nonnull ORValueNode *)node {
    if (node.value_type == OCValueVariable) {
        ocSymbol *symbol = [symbolTableRoot lookup:node.value];
        // NSObject *a = nil;
        // b = a.xxx;
        // a.xxx = b;
        // [[a xxx] yyy];
        // b = a.xxx();
        // 找到 a 的类型 NSObject，并注册为Class
        if (symbol.decl.isStruct == NO
            && symbol.decl.isFunction == NO
            && (symbol == nil || symbol.decl.isObject )) {
            ocDecl *classDecl = [ocDecl new];
            classDecl.typeName = symbol == nil ? node.value : symbol.decl.typeName;
            classDecl.typeEncode = OCTypeStringObject;
            classDecl->isClassRef = YES;
            ocSymbol *symbol = [ocSymbol symbolWithName:classDecl.typeName decl:classDecl];
            [symbolTableRoot insertRoot:symbol];
            return;
        }
        node.symbol = symbol;
    }else if (node.value_type == OCValueSelf){
        
    }
}
- (ocSymbol *)createConstantSymbol:(const char *)typeEncode value:(void *)value{
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = typeEncode;
    decl.offset = or_const_offset;
    decl->isConstant = YES;
    ocSymbol * symbol = [ocSymbol symbolWithName:nil decl:decl];
    or_const_offset += decl.size;
    symbolTableRoot->constants_size = or_const_offset;
    symbolTableRoot->constants = realloc(symbolTableRoot->constants, sizeof(unichar) * symbolTableRoot->constants_size);
    memcpy(symbolTableRoot->constants + decl.offset, value, decl.size);
    return symbol;
}
- (void)visitBoolValue:(nonnull ORBoolValue *)node {
    BOOL value = node.value;
    node.symbol = [self createConstantSymbol:OCTypeStringBOOL value:&value];
}
- (void)visitIntegerValue:(nonnull ORIntegerValue *)node {
    int64_t value = node.value;
    node.symbol = [self createConstantSymbol:OCTypeStringLongLong value:&value];
}
- (void)visitUIntegerValue:(nonnull ORUIntegerValue *)node {
    uint64_t value = node.value;
    node.symbol = [self createConstantSymbol:OCTypeStringULongLong value:&value];
}
- (void)visitDoubleValue:(nonnull ORDoubleValue *)node {
    double value = node.value;
    node.symbol = [self createConstantSymbol:OCTypeStringDouble value:&value];
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
- (void)visitTypeNode:(nonnull ORTypeNode *)node {
    
}

- (void)visitVariableNode:(nonnull ORVariableNode *)node {
    
}

- (void)visitDeclaratorNode:(nonnull ORDeclaratorNode *)node {
    ocDecl *decl = [ocDecl new];
    decl.typeName = node.type.name;
    decl.typeEncode = typeEncodeForDeclaratorNode(node);
    decl.offset = or_mem_offset;
    ocSymbol * symbol = [ocSymbol symbolWithName:node.var.varname decl:decl];
    [symbolTableRoot insert:symbol];
    node.symbol = symbol;
    or_mem_offset += MAX(decl.size, 8);
}
- (void)visitInitDeclaratorNode:(nonnull ORInitDeclaratorNode *)node {
    [self visit:node.declarator];
    [self visit:node.expression];
}
- (void)visitCArrayDeclNode:(nonnull ORCArrayDeclNode *)node {
    ocDecl *decl = [ocDecl new];
    decl.typeName = @"CArray";
    const char *typeEncode = typeEncodeForDeclaratorNode(node);
    if (*typeEncode == OCTypeArray) {
        BOOL isDynamicCArray = NO;
        const char *tmp = typeEncode;
        while (*tmp != '\0') {
            if (*tmp == '%') {
                isDynamicCArray = YES;
                break;
            }
            tmp = tmp + 1;
        }
        decl->isDynamicCArray = YES;
    }
    decl.typeEncode = typeEncode;
    ocSymbol * symbol = [ocSymbol symbolWithName:node.var.varname decl:decl];
    [symbolTableRoot insert:symbol];
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

#pragma mark - Operation Exp
- (void)visitFunctionCall:(nonnull ORFunctionCall *)node {
    [self visit:node.caller];
    for (ORNode *arg in node.expressions) {
        [self visit:arg];
    }
}

- (void)visitMethodCall:(nonnull ORMethodCall *)node {
    [self visit:node.caller];
    for (ORNode *arg in node.values) {
        [self visit:arg];
    }
}

- (void)visitAssignNode:(nonnull ORAssignNode *)node {
    [self visit:node.value];
    [self visit:node.expression];
}

- (void)visitBinaryNode:(nonnull ORBinaryNode *)node {
    [self visit:node.left];
    [self visit:node.right];
}

- (void)visitSubscriptNode:(nonnull ORSubscriptNode *)node {
    [self visit:node.caller];
    [self visit:node.keyExp];
}

- (void)visitTernaryNode:(nonnull ORTernaryNode *)node {
    [self visit:node.expression];
    for (ORNode *value in node.values) {
        [self visit:value];
    }
}
- (void)visitUnaryNode:(nonnull ORUnaryNode *)node {
    [self visit:node.value];
}



@end
