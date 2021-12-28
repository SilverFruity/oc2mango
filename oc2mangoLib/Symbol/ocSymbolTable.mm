//
//  ocSymbolTable.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ocSymbolTable.hpp"
#import "ORFileSection.hpp"

const ocSymbolTable * symbolTableRoot = nil;
const ocScope *scopeRoot = nil;
@implementation ocSymbolTable
- (ORSectionRecorderManager &)recorder {
    return recorder;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scope = [ocScope new];
        scopeRoot = _scope;
    }
    return self;
}
- (ocSymbol *)insert:(ocSymbol *)symbol{
    ocSymbol *localSymbol = [self localLookup:symbol.name];
    if (localSymbol == nil) {
        ocSymbol *globalSymbol = [self lookup:symbol.name];
        if (globalSymbol == nil || globalSymbol != symbol) {
            [self.scope insert:symbol.name symbol:symbol];
        }else{
            symbol = [ocSymbol symbolWithName:symbol.name decl:nil];
            [self.scope insert:symbol.name symbol:symbol];
        }
    }
    return symbol;
}
- (ocSymbol *)insertRoot:(ocSymbol *)symbol{
    return [self insertRootWithName:symbol.name symbol:symbol];
}
- (ocSymbol *)insertRootWithName:(NSString *)name symbol:(ocSymbol *)symbol{
    ocScope *scope = self.scope;
    while (scope.parent != nil) {
        scope = scope.parent;
    }
    [scope insert:name symbol:symbol];
    return symbol;
}
- (ocSymbol *)lookup:(NSString *)name{
    if (name != nil && name.length == 0) {
        return nil;
    }
//    NSAssert(name != nil && name.length > 0, @"");
    ocScope *scope = self.scope;
    ocSymbol *symbol = nil;
    while (symbol == nil && scope != nil)
    {
        symbol = [scope lookup:name];
        scope = scope.parent;
    }
    return symbol;
}
- (ocSymbol *)localLookup:(NSString *)name{
    return [self.scope lookup:name];
}
- (ocScope *)increaseScope{
    ocScope *scope = [ocScope new];
    scope.parent = self.scope;
    self.scope = scope;
    return self.scope;
}
- (ocScope *)decreaseScope{
    self.scope = self.scope.parent;
    return self.scope;
}

@end


@implementation ocSymbolTable (Tools)
- (ocSymbol *)addLinkedClassWithName:(NSString *)name {
    ocSymbol *classSymbol = [symbolTableRoot lookup:name];
    if (classSymbol.decl.isClassRef) {
        return classSymbol;
    }
    ocDecl *classDecl = [ocDecl new];
    classDecl.typeName = name;
    classDecl.typeEncode = OCTypeStringClass;
    classDecl->isLinkedClass = YES;
    classDecl.index = recorder.addLinkedClass(name.UTF8String);
    ocSymbol *symbol = [ocSymbol symbolWithName:classDecl.typeName decl:classDecl];
    [self insertRoot:symbol];
    return symbol;
}
- (ocSymbol *)addStringSection:(const char *)typeencode string:(const char *)str{
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = typeencode;
    if (decl.type == OCTypeObject) {
        decl.index = recorder.addCFString(str);
    }else{
        decl.index = recorder.addCString(str).offset;
    }
    decl->isStringConstant = YES;
    ocSymbol *symbol = [ocSymbol symbolWithName:nil decl:decl];
    return symbol;
}
- (ocSymbol *)addLinkedCFunctionSection:(const char *)typeencode name:(const char *)name {
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = typeencode;
    decl.index = recorder.addLinkedCFunction(typeencode, name);
    decl->isLinkedCFunction = YES;
    ocSymbol *symbol = [ocSymbol symbolWithName:[NSString stringWithUTF8String:name] decl:decl];
    [symbolTableRoot insertRoot:symbol];
    return symbol;
}
- (ocSymbol *)addConstantSection:(const char *)typeencode data:(void *)data {
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = typeencode;
    decl.index = recorder.addConstant(data);
    decl->isConstant = YES;
    ocSymbol *symbol = [ocSymbol symbolWithName:nil decl:decl];
    return symbol;
}
- (ocSymbol *)addDataSection:(const char *)typeencode size:(size_t)size{
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = typeencode;
    decl.index = recorder.addDataSection(size);
    decl->isDataSection = YES;
    ocSymbol *symbol = [ocSymbol symbolWithName:nil decl:decl];
    return symbol;
}
extern const char *typeEncodeForDeclaratorNode(ORDeclaratorNode * node);
- (ocSymbol *)addClassDefineWithName:(ORClassNode *)node {
    ocSymbol *symbol = [self addLinkedClassWithName:node.className];
    symbol.decl->isLinkedClass = NO;
    symbol.decl->isClassDefine = YES;
    recorder.addObjcClass(node.className.UTF8String, node.superClassName.UTF8String);
    return symbol;
}

- (ocSymbol *)addPropertySection:(ORPropertyNode *)node className:(NSString *)className {
    ocDecl *decl = [ocDecl new];
    decl.index = recorder.addObjcProperty(className.UTF8String,
                                          node.modifier,
                                          node.var.type.name.UTF8String,
                                          node.var.var.varname.UTF8String,
                                          typeEncodeForDeclaratorNode(node.var));
    decl->isPropertySection = YES;
    ocSymbol *symbol = [ocSymbol symbolWithName:nil decl:decl];
    return symbol;
}

- (ocSymbol *)addIvarSection:(ORDeclaratorNode *)node className:(NSString *)className {
    recorder.addObjcIvar(className.UTF8String,
                         node.type.name.UTF8String,
                         node.var.varname.UTF8String,
                         typeEncodeForDeclaratorNode(node));
    return nil;
}

- (ocSymbol *)addMethodSection:(ORMethodNode *)node className:(NSString *)className {
    char methodTypeEncode[256] = { 0 };
    const char *returnTypeEncode = typeEncodeForDeclaratorNode(node.declare.returnType);
    strcat(methodTypeEncode, returnTypeEncode);
    strcat(methodTypeEncode, OCTypeStringObject);
    strcat(methodTypeEncode, OCTypeStringSEL);
    for (ORDeclaratorNode *param in node.declare.parameters) {
        strcat(methodTypeEncode, typeEncodeForDeclaratorNode(param));
    }
    if (node.declare.isClassMethod) {
        recorder.addObjcClassMethod(className.UTF8String,
                                    node.declare.selectorName.UTF8String,
                                    methodTypeEncode);
    }else {
        recorder.addObjcInstanceMethod(className.UTF8String,
                                       node.declare.selectorName.UTF8String,
                                       methodTypeEncode);
    }
    return nil;
}

@end


void SymbolTableAddLinkedClassWithName(NSString * name) {
    [symbolTableRoot addLinkedClassWithName:name];
}
