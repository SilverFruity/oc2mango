//
// Created by Jiang on 2019-05-06.
// Copyright (c) 2019 SilverFruity. All rights reserved.
//

#import "CalculateExpression.h"
#import "Expression.h"
#import "JudgementExpression.h"


@implementation CalculateExpression {

}
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
