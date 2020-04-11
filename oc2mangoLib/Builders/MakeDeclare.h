//
//  MakeDeclare.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"
#import "OCValue.h"
#import "Statement.h"



extern TypeSpecial *makeTypeSpecial(TypeKind type, NSString *name);
extern TypeSpecial *makeTypeSpecial(TypeKind type) __attribute__((overloadable)) ;
extern Variable *makeVar(NSString *name, NSUInteger ptCount);
extern Variable *makeVar(NSString *name) __attribute__((overloadable)) ;
extern TypeVarPair *makeTypeVarPair(TypeSpecial *type, Variable *var);

extern OCClass *makeOCClass(NSString *className);
extern MethodDeclare *makeMethodDeclare(BOOL isClassMethod, TypeVarPair *returnType);
extern MethodImplementation *makeMethodImplementation(MethodDeclare *declare);
extern FuncDeclare *makeFuncDeclare(TypeVarPair *returnType, FuncVariable *var);

extern OCValue *makeValue(OC_VALUE_TYPE type, id value);
extern OCValue *makeValue(OC_VALUE_TYPE type) __attribute__((overloadable)) ;
extern CFuncCall *makeFuncCall(OCValue *caller, NSMutableArray *expressions);
extern UnaryExpression *makeUnaryExpression(UnaryOperatorType type);
extern BinaryExpression *makeBinaryExpression(BinaryOperatorType type);
extern TernaryExpression *makeTernaryExpression(void);
extern AssignExpression *makeAssignExpression(AssignOperatorType type);
extern DeclareExpression *makeDeclareExpression(TypeSpecial *type,Variable *var,id <Expression> exp);


extern IfStatement *makeIfStatement(id <Expression>judgement, BlockImp *imp);
extern WhileStatement *makeWhileStatement(id <Expression>judgement, BlockImp *imp);
extern DoWhileStatement *makeDoWhileStatement(id <Expression>judgement, BlockImp *imp);
extern CaseStatement *makeCaseStatement(OCValue *value);
extern SwitchStatement *makeSwitchStatement(OCValue *value);
extern ForStatement *makeForStatement(BlockImp *imp);
extern ForInStatement *makeForInStatement(BlockImp *imp);

extern ReturnStatement *makeReturnStatement(id <ValueExpression> expression);
extern BreakStatement *makeBreakStatement(void);
extern ContinueStatement *makeContinueStatement(void);



void startStringBuffer(void);
char *endStringBuffer(void);
void stringBufferAppendCharacter(char chr);
