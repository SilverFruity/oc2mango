//
//  Statement.h
//  oc2mango
//
//  Created by Jiang on 2019/4/22.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VariableDeclare.h"
#import "Expression.h"
@class FunctionImp;

@interface Statement : NSObject
@property (nonatomic, strong)FunctionImp *funcImp;
@end


@interface IfStatement : Statement
@property (nonatomic,strong)id <Expression> condition;
@property (nonatomic,strong)IfStatement *last;
@end

@interface WhileStatement : Statement
@property (nonatomic,strong)id <Expression> condition;
@end

@interface DoWhileStatement: Statement
@property (nonatomic,strong)id <Expression> condition;
@end

@interface CaseStatement: Statement
@property (nonatomic,strong)OCValue * value;
@end

@interface SwitchStatement : Statement
@property (nonatomic,strong)OCValue * value;
@property (nonatomic,strong)NSMutableArray <CaseStatement *>*cases;
@end

@interface ForStatement : Statement
@property (nonatomic,strong)NSMutableArray <DeclareExpression *>*declareExpressions;
@property (nonatomic,strong)id <Expression> condition;
@property (nonatomic,strong)NSMutableArray <id <Expression>>* expressions;
@end

@interface ForInStatement : Statement
@property (nonatomic,strong)VariableDeclare *declare;
@property (nonatomic,strong)OCValue *value;
@end

@interface ReturnStatement: Statement
@property (nonatomic,strong)id <ValueExpression> expression;
@end

@interface BreakStatement: Statement

@end

@interface ContinueStatement: Statement

@end




