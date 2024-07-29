//
//  Parser.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AST.h"
#import "ORPatchFile.h"
#import "BinaryPatchHelper.h"
NS_ASSUME_NONNULL_BEGIN
@class Parser;
extern Parser *OCParser;
@interface CodeSource: NSObject
@property(nonatomic,nullable,copy)NSString *source;
@property(nonatomic,nullable,copy)NSString *filePath;
@property(nonatomic,nullable,copy)NSString *error;
- (instancetype)initWithFilePath:(NSString *)filePath;
- (instancetype)initWithSource:(NSString *)source;
@end

@interface Parser : NSObject
@property(nonatomic,nonnull,strong)NSLock *lock;
@property(nonatomic,nullable,copy)NSString *error;
@property(nonatomic,nullable,strong)CodeSource *source;
+ (nonnull instancetype)shared;
- (AST *)parseCodeSource:(CodeSource *)source;
- (AST *)parseSource:(nullable NSString *)source;
- (BOOL)isSuccess;
@end
NS_ASSUME_NONNULL_END
