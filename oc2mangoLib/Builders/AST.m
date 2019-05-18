//
//  AST.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "AST.h"


@implementation OCClass
+ (instancetype)classWithClassName:(NSString *)className{
    OCClass *class = [OCClass new];
    class.className = className;
    return class;
}
- (instancetype)init
{
    self = [super init];
    self.properties  = [NSMutableArray array];
    self.privateVariables = [NSMutableArray array];
    self.properties = [NSMutableArray array];
    self.methods = [NSMutableArray array];
    return self;
}
@end
@implementation AST
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static AST * _instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [AST new];
    });
    return _instance;
}
- (OCClass *)classForName:(NSString *)className{
    OCClass *class = self.classCache[className];
    if (!class) {
        class = [OCClass classWithClassName:className];
        self.classCache[className] = class;
    }
    return class;
}
- (instancetype)init
{
    self = [super init];
    self.classCache = [NSMutableDictionary dictionary];
    self.globalStatements = [NSMutableArray array];
    return self;
}
@end

