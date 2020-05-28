//
//  MakeDeclare.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"
#import "RunnerClasses.h"


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
extern ORDeclareExpression *makeDeclareExpression(ORTypeSpecial *type,ORVariable *var,ORExpression * exp);


extern ORIfStatement *makeIfStatement(ORExpression *judgement, ORBlockImp *imp);
extern ORWhileStatement *makeWhileStatement(ORExpression *judgement, ORBlockImp *imp);
extern ORDoWhileStatement *makeDoWhileStatement(ORExpression *judgement, ORBlockImp *imp);
extern ORCaseStatement *makeCaseStatement(ORValueExpression *value);
extern ORSwitchStatement *makeSwitchStatement(ORValueExpression *value);
extern ORForStatement *makeForStatement(ORBlockImp *imp);
extern ORForInStatement *makeForInStatement(ORBlockImp *imp);

extern ORReturnStatement *makeReturnStatement(ORExpression * expression);
extern ORBreakStatement *makeBreakStatement(void);
extern ORContinueStatement *makeContinueStatement(void);

extern ORTypedefExpressoin *makeTypedefExp(id exp,NSString *newName);
extern ORStructExpressoin *makeStructExp(NSString *name, NSMutableArray *fields);
extern OREnumExpressoin *makeEnumExp(NSString *name, ORTypeSpecial *type, NSMutableArray *fields);


void startStringBuffer(void);
char *endStringBuffer(void);
void stringBufferAppendCharacter(char chr);
