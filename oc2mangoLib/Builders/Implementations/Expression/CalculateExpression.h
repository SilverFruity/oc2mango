//
// Created by Jiang on 2019-05-06.
// Copyright (c) 2019 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"

@class JudgementExpression;


// MARK: - Calculate
@interface CalculateExpression : NSObject <ValueExpression>

@end
typedef enum {
    UnaryOperatorIncrement,
    UnaryOperatorDecrement
}UnaryOperatorType;

@interface UnaryExpression: CalculateExpression
@property (nonatomic,assign)UnaryOperatorType operatorType;
@end

typedef enum {
    BinaryOperatorAdd,
    BinaryOperatorSub,
    BinaryOperatorDiv,
    BinaryOperatorMulti,
    BinaryOperatorMod,
    BinaryOperatorShiftLeft,
    BinaryOperatorShiftRight,
    BinaryOperatorAnd,
    BinaryOperatorOr,
    BinaryOperatorXor
}BinaryOperatorType;

@interface BinaryExpression: CalculateExpression
@property (nonatomic,strong)id <ValueExpression> left;
@property (nonatomic,assign) BinaryOperatorType operatorType;
@property (nonatomic,strong)id <ValueExpression> right;
@end

@interface TernaryExpression : CalculateExpression
@property (nonatomic,strong)JudgementExpression *judgeExpression;
@property (nonatomic,strong)NSMutableArray <id <ValueExpression>>*values;
@end