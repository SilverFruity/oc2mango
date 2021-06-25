//
//  ocDecl.m
//  oc2mangoLib
//
//  Created by APPLE on 2021/6/25.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ocDecl.h"
#import "ocHandleTypeEncode.h"

const char *typeEncodeForDeclaratorNode(ORDeclaratorNode * node){
    ORTypeNode *typeSpecial = node.type;
    ORVariableNode *var = node.var;
    OCType type = typeSpecial.type;
    char encoding[128];
    memset(encoding, 0, 128);
#define append(str) strcat(encoding,str)
    NSInteger tmpPtCount = var.ptCount;
    if (tmpPtCount == 0) {
        char type = node.type.type;
        return strdup(&type);
    }
    while (tmpPtCount > 0) {
        if (type == OCTypeChar && tmpPtCount == 1) {
            break;
        }
        append("^");
        tmpPtCount--;
    }
#define CaseTypeEncoding(type)\
case OCType##type:\
append(OCTypeString##type); break;
    
    switch (type) {
        case OCTypeChar:
        {
            if (var.ptCount > 0)
                append(OCTypeStringCString);
            else
                append(OCTypeStringChar);
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
    append("\0");
    return strdup(encoding);
}
@implementation ocDecl
- (instancetype)init
{
    self = [super init];
    if (self) {
        _alignment = 8;
        _typeEncode = NULL;
        _offset = 0;
    }
    return self;
}
- (instancetype)initWithDeclrator:(ORDeclaratorNode *)node{
    self = [super init];
//    char type = node.type.type;
//    if (TypeEncodeCharIsBaseType(type)) {
//        self.typeEncode = typeEncodeForDeclaratorNode(node);
//    }else{
//
//    }
    return self;
}
- (void)setTypeEncode:(const char *)typeEncoding{
    if (_typeEncode != NULL) {
        free((void *)_typeEncode);
        _typeEncode = NULL;
    }
    _typeEncode = typeEncoding;
    if (typeEncoding != NULL) {
        NSUInteger size = 0, alignment = 0;
        NSGetSizeAndAlignment(typeEncoding, &size, &alignment);
        _size = size;
        _alignment = alignment;
        _type = *typeEncoding;
    }
}

- (BOOL)isStruct{
    return _type == OCTypeStruct;
}
- (BOOL)isUnion{
    return _type == OCTypeUnion;
}
- (BOOL)isCArray{
    return _type == OCTypeArray;
}
- (void)dealloc
{
    if (_typeEncode != NULL) {
        free((void *)_typeEncode);
        _typeEncode = NULL;
    }
}
@end



@end
