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
@interface ORAssignExpression : ORExpression <Expression>
@property (nonatomic,strong)ORValueExpression *value;
@property (nonatomic,assign)AssignOperatorType assignType;
@property (nonatomic,strong)id <ValueExpression> expression;
@end


@interface ORDeclareExpression: ORExpression <Expression>
@property (nonatomic,strong)ORTypeVarPair *pair;
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

@interface ORUnaryExpression: ORExpression <ValueExpression>
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

@interface ORBinaryExpression: ORExpression <ValueExpression>
@property (nonatomic,strong)id <ValueExpression> left;
@property (nonatomic,assign) BinaryOperatorType operatorType;
@property (nonatomic,strong)id <ValueExpression> right;
@end

@interface ORTernaryExpression : ORExpression <ValueExpression>
@property (nonatomic,strong)id <ValueExpression> expression;
@property (nonatomic,strong)NSMutableArray <id <ValueExpression>>*values;

@end









