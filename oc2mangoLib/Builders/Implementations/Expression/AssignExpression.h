//
// Created by Jiang on 2019-05-06.
// Copyright (c) 2019 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "VariableDeclare.h"


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

@interface DeclareAssignExpression: AssignExpression
@property (nonatomic,strong)VariableDeclare *declare;
@end

@interface VariableAssignExpression: AssignExpression
@property (nonatomic,strong)OCValue *value;
@property (nonatomic,assign)AssignOperatorType assignType;
@end