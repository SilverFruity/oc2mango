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
    BOOL isProperty;
    BOOL isIvar;
    BOOL isMethod;
    BOOL isClassMethod;
    BOOL isClassRef;
}
@property (nonatomic, assign)OCType type;
@property (nonatomic, copy)NSString *typeName;
@property (nonatomic, assign)const char *typeEncode;
@property (nonatomic, assign)NSUInteger size;
@property (nonatomic, assign)NSUInteger offset;
@property (nonatomic, assign)NSUInteger alignment;

@property (nonatomic, assign)DeclarationModifier declModifer;
@property (nonatomic, assign)MFPropertyModifier propModifer;

- (BOOL)isStruct;
- (BOOL)isUnion;
- (BOOL)isCArray;
/// @?
- (BOOL)isObject;
- (BOOL)isBlock;
/// ^?
- (BOOL)isFunction;

- (BOOL)isProperty;
- (BOOL)isIvar;
- (BOOL)isMethod;
- (BOOL)isClassMethod;

// Data Section
- (BOOL)isStatic;
- (BOOL)isConst;
- (BOOL)isClassRef;
@end

@interface ocComposeDecl: ocDecl
@property (nonatomic, assign)ocScope *fielsScope;
@end

NS_ASSUME_NONNULL_END
