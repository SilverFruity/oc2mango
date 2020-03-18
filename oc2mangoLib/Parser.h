//
//  Parser.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AST.h"
#define OCParser [Parser shared]
#define LibAst OCParser.ast

@interface Parser : NSObject
@property(nonatomic,nonnull,strong)AST *ast;
@property(nonatomic,nonnull,strong)NSLock *lock;
@property(nonatomic,nullable,copy)NSString *error;
@property(nonatomic,nullable,copy)NSString *source;
+ (nonnull instancetype)shared;
- (void)parseSource:(NSString *)source;
- (BOOL)isSuccess;
- (void)clear;
@end


