//
//  ocSymbolTable.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ocSymbolTable.h"
#import "ORFileSection.h"
const ocSymbolTable * symbolTableRoot = nil;
const ocScope *scopeRoot = nil;
@implementation ocSymbolTable
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scope = [ocScope new];
        scopeRoot = _scope;
        string_recorder = init_string_recorder();
        cfstring_recorder = init_cfstring_recorder();
        data_section_recorder = init_data_section_recorder();
        constant_recorder = init_constant_section_recorder();
        linked_class_recorder = init_linked_class_recorder();
        linked_cfunction_recorder = init_linked_cfunction_recorder();
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
- (ocSymbol *)addClassDefineWithName:(NSString *)name {
    ocSymbol *symbol = [self addLinkedClassWithName:name];
    symbol.decl->isLinkedClass = NO;
    symbol.decl->isClassDefine = YES;
    return symbol;
}
- (ocSymbol *)addLinkedClassWithName:(NSString *)name {
    ocSymbol *classSymbol = [symbolTableRoot lookup:name];
    if (classSymbol.decl.isClassRef) {
        return classSymbol;
    }
    ocDecl *classDecl = [ocDecl new];
    classDecl.typeName = name;
    classDecl.typeEncode = OCTypeStringClass;
    classDecl->isLinkedClass = YES;
    classDecl.index = or_linked_class_recorder_add(name.UTF8String);
    ocSymbol *symbol = [ocSymbol symbolWithName:classDecl.typeName decl:classDecl];
    [self insertRoot:symbol];
    return symbol;
}
- (ocSymbol *)addStringSection:(const char *)typeencode string:(const char *)str{
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = typeencode;
    if (decl.type == OCTypeObject) {
        decl.index = or_cfstring_recorder_add(str);
    }else{
        decl.index = or_string_recorder_add(str);
    }
    decl->isStringConstant = YES;
    ocSymbol *symbol = [ocSymbol symbolWithName:nil decl:decl];
    return symbol;
}
- (ocSymbol *)addLinkedCFunctionSection:(const char *)typeencode name:(const char *)name {
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = typeencode;
    decl.index = or_linked_cfunction_recorder_add(typeencode, name);
    decl->isLinkedCFunction = YES;
    ocSymbol *symbol = [ocSymbol symbolWithName:[NSString stringWithUTF8String:name] decl:decl];
    [symbolTableRoot insertRoot:symbol];
    return symbol;
}
- (ocSymbol *)addConstantSection:(const char *)typeencode data:(void *)data {
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = typeencode;
    decl.index = or_constant_section_recorder_add(data);
    decl->isConstant = YES;
    ocSymbol *symbol = [ocSymbol symbolWithName:nil decl:decl];
    return symbol;
}
- (ocSymbol *)addDataSection:(const char *)typeencode size:(size_t)size{
    ocDecl *decl = [ocDecl new];
    decl.typeEncode = typeencode;
    decl.index = or_data_section_recorder_add(size);
    decl->isDataSection = YES;
    ocSymbol *symbol = [ocSymbol symbolWithName:nil decl:decl];
    return symbol;
}

@end
