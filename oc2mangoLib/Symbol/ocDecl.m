//
//  ocDecl.m
//  oc2mangoLib
//
//  Created by APPLE on 2021/6/25.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ocDecl.h"
#import "ocHandleTypeEncode.h"

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

@implementation ocComposeDecl

@end
