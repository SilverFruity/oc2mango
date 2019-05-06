//
// Created by Jiang on 2019-05-06.
// Copyright (c) 2019 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"


typedef enum {
    JudgementOperatorLT,
    JudgementOperatorGT,
    JudgementOperatorLE,
    JudgementOperatorGE,
    JudgementOperatorNE,
    JudgementOperatorEQ,
    JudgementOperatorAND,
    JudgementOperatorOR,
    JudgementOperatorNOT,
}JudgementOperatorType;
@interface JudgementExpression: NSObject <ValueExpression>
@property (nonatomic,strong)id <ValueExpression> left;
@property (nonatomic,assign)JudgementOperatorType operatorType;
@property (nonatomic,strong)id <ValueExpression> right;

@end