//
//  Expression.m
//  oc2mango
//
//  Created by Jiang on 2019/4/22.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Expression.h"


@implementation AssignExpression {
    
}
@end


@implementation DeclareExpression


@end

@implementation UnaryExpression

@end

@implementation BinaryExpression
@end

@implementation TernaryExpression
- (instancetype)init
{
    self = [super init];
    self.values = [NSMutableArray array];
    return self;
}
@end
