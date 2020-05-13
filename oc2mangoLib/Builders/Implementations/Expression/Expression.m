//
//  Expression.m
//  oc2mango
//
//  Created by Jiang on 2019/4/22.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Expression.h"

@implementation ORCodeCheck
@end

@implementation ORExpression

@end
@implementation ORAssignExpression {
    
}
@end


@implementation ORDeclareExpression


@end

@implementation ORUnaryExpression

@end

@implementation ORBinaryExpression
@end

@implementation ORTernaryExpression
- (instancetype)init
{
    self = [super init];
    self.values = [NSMutableArray array];
    return self;
}
@end
