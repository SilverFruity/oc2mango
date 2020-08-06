//
//  AST.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunnerClasses.h"
NS_ASSUME_NONNULL_BEGIN
int startClassProrityDetect(ORClass *class);
@interface AST : NSObject
@property(nonatomic,nonnull,strong)NSMutableArray *globalStatements;
@property(nonatomic,nonnull,strong)NSMutableDictionary *classCache;
@property(nonatomic,nonnull,strong)NSMutableDictionary *protcolCache;
- (nonnull ORClass *)classForName:(NSString *)className;
- (nonnull ORProtocol *)protcolForName:(NSString *)protcolName;
- (void)addGlobalStatements:(id)objects;
- (NSArray <ORClass *>*)sortClasses;
@end
NS_ASSUME_NONNULL_END
