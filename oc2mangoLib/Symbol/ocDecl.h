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
@property (nonatomic, assign)OCType type;
@property (nonatomic, copy)NSString *typeName;
@property (nonatomic, assign)const char *typeEncode;
@property (nonatomic, assign)NSUInteger size;
@property (nonatomic, assign)NSUInteger offset;
@property (nonatomic, assign)NSUInteger alignment;
- (instancetype)initWithDeclrator:(ORDeclaratorNode *)node;
- (BOOL)isStruct;
- (BOOL)isUnion;
- (BOOL)isCArray;
@end

@interface ocComposeDecl: ocDecl
@property (nonatomic, assign)ocScope *fielsScope;
@end

NS_ASSUME_NONNULL_END
