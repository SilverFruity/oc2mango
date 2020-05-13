//
//  Statement.h
//  oc2mango
//
//  Created by Jiang on 2019/4/22.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
@class ORBlockImp;

@interface ORStatement : NSObject
@property (nonatomic, strong)ORBlockImp *funcImp;
@end


@interface ORIfStatement : ORStatement
@property (nonatomic,strong)ORExpression * condition;
@property (nonatomic,strong)ORIfStatement *last;
@end

@interface ORWhileStatement : ORStatement
@property (nonatomic,strong)ORExpression * condition;
@end

@interface ORDoWhileStatement: ORStatement
@property (nonatomic,strong)ORExpression * condition;
@end

@interface ORCaseStatement: ORStatement
@property (nonatomic,strong)ORValueExpression * value;
@end

@interface ORSwitchStatement : ORStatement
@property (nonatomic,strong)ORValueExpression * value;
@property (nonatomic,strong)NSMutableArray <ORCaseStatement *>*cases;
@end

@interface ORForStatement : ORStatement
@property (nonatomic,strong)NSMutableArray <ORDeclareExpression *>*declareExpressions;
@property (nonatomic,strong)ORExpression * condition;
@property (nonatomic,strong)NSMutableArray <ORExpression *>* expressions;
@end

@interface ORForInStatement : ORStatement
@property (nonatomic,strong)ORDeclareExpression *expression;
@property (nonatomic,strong)ORValueExpression *value;
@end

@interface ORReturnStatement: ORStatement
@property (nonatomic,strong)ORExpression * expression;
@end

@interface ORBreakStatement: ORStatement

@end

@interface ORContinueStatement: ORStatement

@end




