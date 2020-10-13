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
extern ORProtocol *makeORProtcol(NSString *protocolName);
extern ORMethodDeclare *makeMethodDeclare(BOOL isClassMethod, ORTypeVarPair *returnType);
extern ORMethodImplementation *makeMethodImplementation(ORMethodDeclare *declare, ORScopeImp *scopeImp);
extern ORFuncDeclare *makeFuncDeclare(ORTypeVarPair *returnType, ORFuncVariable *var);

extern ORValueExpression *makeValue(OC_VALUE_TYPE type, id value);
extern ORValueExpression *makeValue(OC_VALUE_TYPE type) __attribute__((overloadable)) ;
extern ORScopeImp *makeScopeImp(void);
extern ORCFuncCall *makeFuncCall(ORNode *caller, NSMutableArray *expressions);
extern ORUnaryExpression *makeUnaryExpression(UnaryOperatorType type);
extern ORBinaryExpression *makeBinaryExpression(BinaryOperatorType type);
extern ORTernaryExpression *makeTernaryExpression(void);
extern ORAssignExpression *makeAssignExpression(AssignOperatorType type);
extern ORDeclareExpression *makeDeclareExpression(ORTypeSpecial *type,ORVariable *var,ORNode * exp);


extern ORIfStatement *makeIfStatement(ORNode *judgement, ORScopeImp *imp);
extern ORWhileStatement *makeWhileStatement(ORNode *judgement, ORScopeImp *imp);
extern ORDoWhileStatement *makeDoWhileStatement(ORNode *judgement, ORScopeImp *imp);
extern ORCaseStatement *makeCaseStatement(ORValueExpression *value);
extern ORSwitchStatement *makeSwitchStatement(ORValueExpression *value);
extern ORForStatement *makeForStatement(ORScopeImp *imp);
extern ORForInStatement *makeForInStatement(ORScopeImp *imp);

extern ORReturnStatement *makeReturnStatement(ORNode * expression);
extern ORBreakStatement *makeBreakStatement(void);
extern ORContinueStatement *makeContinueStatement(void);

extern ORTypedefExpressoin *makeTypedefExp(id exp,NSString *newName);
extern ORStructExpressoin *makeStructExp(NSString *name, NSMutableArray *fields);
extern OREnumExpressoin *makeEnumExp(NSString *name, ORTypeSpecial *type, NSMutableArray *fields);

extern ORNode *makeIntegerValue(uint64_t value);
extern ORDoubleValue *makeDoubleValue(double value);
extern ORBoolValue *makeBoolValue(BOOL value);

void startStringBuffer(void);
char *endStringBuffer(void);
void stringBufferAppendCharacter(char chr);
void stringBufferAppendString(char *str);
