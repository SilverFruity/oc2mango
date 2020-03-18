//
//  Expression.h
//  oc2mango
//
//  Created by Jiang on 2019/4/22.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeSpecial.h"
@class OCValue;


@protocol Expression <NSObject>

@end
@protocol ValueExpression <Expression>

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
@property (nonatomic,strong)TypeSpecial *type;
@property (nonatomic,strong)Variable *var;
@property (nonatomic,strong)id <Expression> expression;
@end




typedef enum {
    UnaryOperatorIncrementSuffix,
    UnaryOperatorDecrementSuffix,
    UnaryOperatorIncrementPrefix,
    UnaryOperatorDecrementPrefix,
    UnaryOperatorNot,
    UnaryOperatorNegative,
    UnaryOperatorBiteNot,
    UnaryOperatorSizeOf,
    UnaryOperatorAdressPoint,
    UnaryOperatorAdressValue
}UnaryOperatorType;

@interface UnaryExpression: NSObject <ValueExpression>
@property (nonatomic,strong)id <ValueExpression> value;
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
    BinaryOperatorXor,
    BinaryOperatorLT,
    BinaryOperatorGT,
    BinaryOperatorLE,
    BinaryOperatorGE,
    BinaryOperatorNotEqual,
    BinaryOperatorEqual,
    BinaryOperatorLOGIC_AND,
    BinaryOperatorLOGIC_OR
}BinaryOperatorType;

@interface BinaryExpression: NSObject <ValueExpression>
@property (nonatomic,strong)id <ValueExpression> left;
@property (nonatomic,assign) BinaryOperatorType operatorType;
@property (nonatomic,strong)id <ValueExpression> right;
@end

@interface TernaryExpression : NSObject <ValueExpression>
@property (nonatomic,strong)id <ValueExpression> expression;
@property (nonatomic,strong)NSMutableArray <id <ValueExpression>>*values;

@end









