//
//  Expression.h
//  oc2mango
//
//  Created by Jiang on 2019/4/22.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VariableDeclare.h"


@protocol Expression <NSObject>

@end
@protocol ValueExpression <Expression>

@end

// MARK: - ValueType
typedef enum {
    OCValueObject,
    OCValueSelf,
    OCValueSuper,
    OCValueNumber,
    OCValueBlock,
    OCValueConvert,
    OCValueNil,
    OCValueNULL,
    OCValueDictionary,
    OCValueArray,
    OCValueNSNumber,
    OCValueString,
    OCValuePointValue,
    OCValueVarPoint,
    OCValueMethodCall
}OC_VALUE_TYPE;

@interface OCValueType: NSObject <ValueExpression>
@property (nonatomic,assign)OC_VALUE_TYPE value_type;
@end

@interface OCMethodCall : OCValueType
@property (nonatomic, strong)OCMethodCall *caller;
@property (nonatomic, strong)NSMutableArray *names;
@property (nonatomic, strong)NSMutableArray <id <ValueExpression>> *values;
@end

typedef enum {
    AssignOperatorAssign,
    AssignOperatorAssignAnd,
    AssignOperatorAssignOr,
    AssignOperatorAssignXor,
    AssignOperatorAssignAdd,
    AssignOperatorAssignSub,
    AssignOperatorAssignDiv,
    AssignOperatorAssignMuti,
    AssignOperatorAssignMod
}AssignOperatorType;

// MARK: - Assign
@interface AssignExpression : NSObject <Expression>
@property (nonatomic,strong)id <ValueExpression> expression;
@end

@interface DeclareAssignExrepssion: AssignExpression
@property (nonatomic,strong)VariableDeclare *declare;
@end

@interface VariableAssignExpression: AssignExpression
@property (nonatomic,strong)OCValueType *value;
@property (nonatomic,assign)AssignOperatorType assignType;
@end

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
@interface JudgementExpressoin: NSObject <ValueExpression>
@property (nonatomic,strong)id <ValueExpression> left;
@property (nonatomic,assign)JudgementOperatorType operatorType;
@property (nonatomic,strong)id <ValueExpression> right;

@end

// MARK: - Calculate
@interface CalculatorExpression : NSObject <ValueExpression>

@end
typedef enum {
    UnaryOperatorIncrement,
    UnaryOperatorDecrement
}UnaryOperatorType;

@interface UnaryExpression: CalculatorExpression
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

@interface BinaryExpression: CalculatorExpression
@property (nonatomic,strong)id <ValueExpression> left;
@property (nonatomic,assign)BinaryOperatorType operatorType;
@property (nonatomic,strong)id <ValueExpression> right;
@end

@interface TernaryExpression : CalculatorExpression
@property (nonatomic,strong)JudgementExpressoin *judgeExpression;
@property (nonatomic,strong)NSMutableArray <id <ValueExpression>>*values;
@end

typedef enum{
    ControlExpressionReturn,
    ControlExpressionBreak,
    ControlExpressionContinue,
    ControlExpressionGoto
}ControlExpressionType;

// MARK: - Control
@interface ControlExpression: NSObject <Expression>
@property (nonatomic,assign)ControlExpressionType controlType;
@end




