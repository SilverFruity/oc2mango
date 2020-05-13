//
//  Expression.h
//  oc2mango
//
//  Created by Jiang on 2019/4/22.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORTypeSpecial.h"
@class ORValueExpression;


@protocol Expression <NSObject>

@end
@protocol ValueExpression <Expression>

@end

@interface ORCodeCheck : NSObject
@property (nonatomic, assign)NSInteger lineNum;
@property (nonatomic, assign)NSInteger columnStart;
@property (nonatomic, assign)NSInteger length;
@property (nonatomic, copy)NSString *filename;
@end

@interface ORExpression: ORCodeCheck

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
@interface ORAssignExpression : ORExpression
@property (nonatomic,strong)ORValueExpression *value;
@property (nonatomic,assign)AssignOperatorType assignType;
@property (nonatomic,strong)ORExpression *expression;
@end


@interface ORDeclareExpression: ORExpression
@property (nonatomic,strong)ORTypeVarPair *pair;
@property (nonatomic,strong)ORExpression *expression;
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

@interface ORUnaryExpression: ORExpression
@property (nonatomic,strong)ORExpression *value;
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

@interface ORBinaryExpression: ORExpression
@property (nonatomic,strong)ORExpression *left;
@property (nonatomic,assign)BinaryOperatorType operatorType;
@property (nonatomic,strong)ORExpression *right;
@end

@interface ORTernaryExpression : ORExpression
@property (nonatomic,strong)ORExpression *expression;
@property (nonatomic,strong)NSMutableArray <ORExpression *>*values;

@end









