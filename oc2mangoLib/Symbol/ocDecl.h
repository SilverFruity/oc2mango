//
//  ocDecl.h
//  oc2mangoLib
//
//  Created by APPLE on 2021/6/25.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ORPatchFile/ORPatchFile.h>
NS_ASSUME_NONNULL_BEGIN

@interface ocDecl : NSObject
{
@public
    BOOL isInternalIvar;
    BOOL isProperty;
    BOOL isIvar;
    BOOL isMethod;
    BOOL isClassMethod;
    BOOL isClassRef;
    BOOL isDynamicCArray;
    BOOL isSelf;
    BOOL isSuper;
    
    // Data Section
    BOOL isConstant;
    BOOL isStringConstant;
    BOOL isLinkedCFunction;
    BOOL isLinkedClass;
    BOOL isDataSection;
    
    NSUInteger _offset;
    NSUInteger _size;
    const char *_typeEncode;
}
@property (nonatomic, assign)OCType type;
@property (nonatomic, copy)NSString *typeName;
@property (nonatomic, assign)const char *typeEncode;
@property (nonatomic, assign)NSUInteger size;
@property (nonatomic, assign)NSUInteger offset;
@property (nonatomic, assign)NSUInteger alignment;

@property (nonatomic, assign)DeclarationModifier declModifer;
@property (nonatomic, assign)MFPropertyModifier propModifer;
+ (instancetype)declWithTypeEncode:(const char *)typeEncode;
- (BOOL)isStruct;
- (BOOL)isUnion;
- (BOOL)isCArray;
/// @?
- (BOOL)isObject;
- (BOOL)isBlock;
/// ^?
- (BOOL)isFunction;

- (BOOL)isDynamicCArray;

- (BOOL)isProperty;
- (BOOL)isIvar;
- (BOOL)isMethod;
- (BOOL)isClassMethod;

// Data Section
- (BOOL)isStatic;
- (BOOL)isConstant;
- (BOOL)isClassRef;
@end

@interface ocComposeDecl: ocDecl
@property (nonatomic, strong)NSMutableArray *keys;
@property (nonatomic, assign)ocScope *fielsScope;
@end

NS_ASSUME_NONNULL_END
