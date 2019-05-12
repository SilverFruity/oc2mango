//
// Created by Jiang on 2019-05-06.
// Copyright (c) 2019 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"


typedef enum{
    ControlExpressionReturn,
    ControlExpressionBreak,
    ControlExpressionContinue,
    ControlExpressionGoto
}ControlExpressionType;

// MARK: - Control
@interface ControlExpression: NSObject <Expression>
@property (nonatomic,assign)ControlExpressionType controlType;
@property (nonatomic,strong)id <ValueExpression> expression;
@end
