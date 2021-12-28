//
//  ocDecl.h
//  oc2mangoLib
//
//  Created by APPLE on 2021/6/25.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCTypeEncode.h"
#import "RunnerClasses.h"

NS_ASSUME_NONNULL_BEGIN

@interface ocDecl : NSObject
{
@public
    enum {
        isArgument,
        isLocalVar,
        isIvar,
        isGlobalVar
    } variable;
    
    BOOL isArgument;
    BOOL isLocalVar;
    
    BOOL isIvar;
    BOOL isClassDefine;
    BOOL isDynamicCArray;
    BOOL isSelf;
    BOOL isSuper;
    
    union {
        BOOL isFunctionDefine;
        BOOL isBlockDefine;
    } functionDefine;
    
    // Data Section
    BOOL isConstant;
    BOOL isStringConstant;
    BOOL isLinkedCFunction;
    BOOL isLinkedClass;
    BOOL isDataSection;
    
    BOOL isClassSection;
    BOOL isMethodSection;
    BOOL isPropertySection;
    
    unsigned int _size;
    const char *_typeEncode;
}
@property (nonatomic, assign)OCType type;
@property (nonatomic, copy)NSString *typeName;
@property (nonatomic, assign)const char *typeEncode;
@property (nonatomic, assign)unsigned int size;
@property (nonatomic, assign)unsigned int index;
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
- (BOOL)isFunctionDefine;
- (BOOL)isLinkedCFunction;

- (BOOL)isDynamicCArray;

- (BOOL)isIvar;

// Data Section
- (BOOL)isStatic;
- (BOOL)isConstant;
- (BOOL)isClassRef;
@end

@interface ocComposeDecl: ocDecl
@property (nonatomic, strong)NSMutableArray *keys;
@property (nonatomic, assign)ocScope *fielsScope;
@end

@interface ocFunctionDecl: ocDecl
@property (nonatomic, strong)ocDecl *returnDecl;
@property (nonatomic, strong)NSMutableArray *argsDecl;
@property (nonatomic, assign)int argsSize;
@property (nonatomic, assign)int localVarsSize;
@end

@interface ocMethodDecl: ocDecl
@property (nonatomic, strong)ocDecl *returnDecl;
@property (nonatomic, strong)NSMutableArray *argsDecl;
@property (nonatomic, assign)int argsSize;
@property (nonatomic, assign)int localVarsSize;
@end

NS_ASSUME_NONNULL_END
