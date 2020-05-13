//
//  AST.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunnerClasses.h"
@interface AST : NSObject
@property(nonatomic,nonnull,strong)NSMutableArray *globalStatements;
@property(nonatomic,nonnull,strong)NSMutableDictionary *classCache;
- (nonnull ORClass *)classForName:(NSString *)className;
- (void)addGlobalStatements:(id)objects;
@end
