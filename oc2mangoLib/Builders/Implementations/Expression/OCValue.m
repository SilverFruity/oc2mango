//
// Created by Jiang on 2019-05-06.
// Copyright (c) 2019 SilverFruity. All rights reserved.
//

#import "OCValue.h"


@implementation OCValue


@end

@implementation OCMethodCall

@end

@implementation CFuncCall

@end

@implementation BlockImp
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
- (void)copyFromImp:(BlockImp *)imp{
    self.statements = imp.statements;
}
@end
@implementation OCCollectionGetValue


@end
