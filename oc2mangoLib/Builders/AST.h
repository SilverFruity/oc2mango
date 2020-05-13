//
//  AST.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORPropertyDeclare.h"
#import "ORMethodImplementation.h"

@interface ORClass: NSObject
+ (instancetype)classWithClassName:(NSString *)className;
@property (nonatomic,copy)NSString *className;
@property (nonatomic,copy)NSString *superClassName;
@property (nonatomic,strong)NSMutableArray <NSString *>*protocols;
@property (nonatomic,strong)NSMutableArray <ORPropertyDeclare *>*properties;
@property (nonatomic,strong)NSMutableArray <ORTypeVarPair *>*privateVariables;
@property (nonatomic,strong)NSMutableArray <ORMethodImplementation *>*methods;
@end

@interface AST : NSObject
@property(nonatomic,nonnull,strong)NSMutableArray *globalStatements;
@property(nonatomic,nonnull,strong)NSMutableDictionary *classCache;
- (nonnull ORClass *)classForName:(NSString *)className;
- (void)addGlobalStatements:(id)objects;
@end
