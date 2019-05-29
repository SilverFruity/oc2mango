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

extern VariableDeclare *makeVariableDeclare(TypeSpecial *type, NSString *name);
extern OCClass *makeOCClass(NSString *className);
extern MethodDeclare *makeMethodDeclare(BOOL isClassMethod, TypeSpecial *returnType);
extern MethodImplementation *makeMethodImplementation(MethodDeclare *declare);
extern FuncDeclare *makeFuncDeclare(TypeSpecial *returnType,NSMutableArray *vars, NSString *name);
extern FuncDeclare *makeFuncDeclare(TypeSpecial *returnType,NSMutableArray *vars) __attribute__((overloadable));

extern OCValue *makeValue(OC_VALUE_TYPE type, id value);
extern OCValue *makeValue(OC_VALUE_TYPE type) __attribute__((overloadable)) ;

extern UnaryExpression *makeUnaryExpression(UnaryOperatorType type);
extern BinaryExpression *makeBinaryExpression(BinaryOperatorType type);
extern TernaryExpression *makeTernaryExpression(void);
extern AssignExpression *makeAssignExpression(AssignOperatorType type);
extern DeclareExpression *makeDeclareExpression(TypeSpecial *type,OCValue *value,id <Expression> exp);


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



extern void pushFuncSymbolTable(void);
extern void popFuncSymbolTable(void);
extern Symbol *lookupSymbol(NSString *name);
extern void addVariableSymbol(TypeSpecial *type,NSString *name);
extern void addTypeSymbol(TypeSpecial *type,NSString *name);
extern void addTypeDefSymbol(TypeSpecial *type,NSString *name);
extern void addEnumConstantSybol(NSString *name);


extern void appendCharacter(char chr);
NSString * getString(void);
