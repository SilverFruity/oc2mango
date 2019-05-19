//
//  AST.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PropertyDeclare.h"
#import "MethodImplementation.h"

@interface OCClass: NSObject
+ (instancetype)classWithClassName:(NSString *)className;
@property (nonatomic,copy)NSString *className;
@property (nonatomic,copy)NSString *superClassName;
@property (nonatomic,strong)NSMutableArray <NSString *>*protocols;
@property (nonatomic,strong)NSMutableArray <PropertyDeclare *>*properties;
@property (nonatomic,strong)NSMutableArray <VariableDeclare *>*privateVariables;
@property (nonatomic,strong)NSMutableArray <MethodImplementation *>*methods;
@end

@interface AST : NSObject
@property(nonatomic,nonnull,strong)NSMutableArray *globalStatements;
@property(nonatomic,nonnull,strong)NSMutableDictionary *classCache;
- (nonnull OCClass *)classForName:(NSString *)className;
+ (instancetype)shared;
- (void)clear;
@end
