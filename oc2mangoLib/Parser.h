//
//  Parser.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <oc2mangoLib/ClassImplementation.h>
#import <oc2mangoLib/ClassDeclare.h>
#define OCParser [Parser shared]
@interface Parser : NSObject
@property(nonatomic,strong)NSMutableArray <ClassDeclare *>*classInterfaces;
@property(nonatomic,strong)NSMutableArray <ClassImplementation *>*classImps;
@property(nonatomic,nullable,copy)NSString *error;
@property(nonatomic,nullable,copy)NSString *source;

- (nonnull NSArray *)expressions;
- (nonnull NSArray *)statements;
+ (instancetype)shared;
- (void)parseSource:(nullable NSString *)source;
- (void)clear;
@end
