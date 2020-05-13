//
//  MakeDeclare.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"
#import "ORValueExpression.h"
#import "ORStatement.h"



extern ORTypeSpecial *makeTypeSpecial(TypeKind type, NSString *name);
extern ORTypeSpecial *makeTypeSpecial(TypeKind type) __attribute__((overloadable)) ;
extern ORVariable *makeVar(NSString *name, NSUInteger ptCount);
extern ORVariable *makeVar(NSString *name) __attribute__((overloadable)) ;
extern ORTypeVarPair *makeTypeVarPair(ORTypeSpecial *type, ORVariable *var);

extern ORClass *makeOCClass(NSString *className);
extern ORMethodDeclare *makeMethodDeclare(BOOL isClassMethod, ORTypeVarPair *returnType);
extern ORMethodImplementation *makeMethodImplementation(ORMethodDeclare *declare);
extern ORFuncDeclare *makeFuncDeclare(ORTypeVarPair *returnType, ORFuncVariable *var);

extern ORValueExpression *makeValue(OC_VALUE_TYPE type, id value);
extern ORValueExpression *makeValue(OC_VALUE_TYPE type) __attribute__((overloadable)) ;
extern ORCFuncCall *makeFuncCall(ORValueExpression *caller, NSMutableArray *expressions);
extern ORUnaryExpression *makeUnaryExpression(UnaryOperatorType type);
extern ORBinaryExpression *makeBinaryExpression(BinaryOperatorType type);
extern ORTernaryExpression *makeTernaryExpression(void);
extern ORAssignExpression *makeAssignExpression(AssignOperatorType type);
extern ORDeclareExpression *makeDeclareExpression(ORTypeSpecial *type,ORVariable *var,id <Expression> exp);


extern ORIfStatement *makeIfStatement(id <Expression>judgement, ORBlockImp *imp);
extern ORWhileStatement *makeWhileStatement(id <Expression>judgement, ORBlockImp *imp);
extern ORDoWhileStatement *makeDoWhileStatement(id <Expression>judgement, ORBlockImp *imp);
extern ORCaseStatement *makeCaseStatement(ORValueExpression *value);
extern ORSwitchStatement *makeSwitchStatement(ORValueExpression *value);
extern ORForStatement *makeForStatement(ORBlockImp *imp);
extern ORForInStatement *makeForInStatement(ORBlockImp *imp);

extern ORReturnStatement *makeReturnStatement(id <ValueExpression> expression);
extern ORBreakStatement *makeBreakStatement(void);
extern ORContinueStatement *makeContinueStatement(void);



void startStringBuffer(void);
char *endStringBuffer(void);
void stringBufferAppendCharacter(char chr);
