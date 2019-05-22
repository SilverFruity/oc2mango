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
    AssignOperatorAssignMod,
    AssignOperatorAssignShiftLeft,
    AssignOperatorAssignShiftRight,
}AssignOperatorType;

// MARK: - Assign
@interface AssignExpression : NSObject <Expression>
@property (nonatomic,strong)OCValue *value;
@property (nonatomic,assign)AssignOperatorType assignType;
@property (nonatomic,strong)id <ValueExpression> expression;
@end


@interface DeclareExpression: NSObject <Expression>
@property (nonatomic,strong)VariableDeclare *declare;
@property (nonatomic,strong)id <ValueExpression> expression;
@end
