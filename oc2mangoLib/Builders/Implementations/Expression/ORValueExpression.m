//
// Created by Jiang on 2019-05-06.
// Copyright (c) 2019 SilverFruity. All rights reserved.
//

#import "ORValueExpression.h"


@implementation ORValueExpression


@end

@implementation ORMethodCall

@end

@implementation ORCFuncCall

@end

@implementation ORBlockImp
- (instancetype)init
{
    self = [super init];
    self.statements = [NSMutableArray array];
    return self;
}
- (void)addStatements:(id)statements{
    if ([statements isKindOfClass:[NSArray class]]) {
        [self.statements addObjectsFromArray:statements];
    }else{
        [self.statements addObject:statements];
    }
}
- (void)copyFromImp:(ORBlockImp *)imp{
    self.statements = imp.statements;
}
@end
@implementation ORSubscriptExpression


@end
