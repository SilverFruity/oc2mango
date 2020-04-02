//
//  MakeDeclare.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "MakeDeclare.h"


TypeSpecial *makeTypeSpecial(TypeKind type ,NSString *name){
    return [TypeSpecial specialWithType:type name:name];
}
TypeSpecial *makeTypeSpecial(TypeKind type) __attribute__((overloadable)){
    return makeTypeSpecial(type, nil);
}
Variable *makeVar(NSString *name, NSUInteger ptCount){
    Variable *var = [Variable new];
    var.ptCount = ptCount;
    var.varname = name;
    return var;
}
Variable *makeVar(NSString *name) __attribute__((overloadable)){
    return makeVar(name, 0);
}
extern TypeVarPair *makeTypeVarPair(TypeSpecial *type, Variable *var){
    TypeVarPair *pair = [TypeVarPair new];
    pair.type = type;
    pair.var = var;
    return pair;
}

OCClass *makeOCClass(NSString *className){
    return [OCClass classWithClassName:className];
}

MethodDeclare *makeMethodDeclare(BOOL isClassMethod, TypeVarPair *returnType){
    MethodDeclare *method = [MethodDeclare new];
    method.methodNames = [NSMutableArray array];
    method.parameterNames  = [NSMutableArray array];
    method.parameterTypes = [NSMutableArray array];
    method.isClassMethod = isClassMethod;
    method.returnType = returnType;
    return method;
}
FuncDeclare *makeFuncDeclare(TypeVarPair *returnType,FuncVariable *var){
    FuncDeclare *decl = [FuncDeclare new];
    decl.returnType = returnType;
    decl.var = var;
    return decl;
}

MethodImplementation *makeMethodImplementation(MethodDeclare *declare){
    MethodImplementation *imp = [MethodImplementation new];
    imp.declare = declare;
    return imp;
}



OCValue *makeValue(OC_VALUE_TYPE type, id value){
    OCValue *ocvalue;
    switch (type){
        case OCValueMethodCall:
            ocvalue = [OCMethodCall new];
            break;
        case OCValueFuncCall:
            ocvalue = [CFuncCall new];
            break;
        case OCValueBlock:
            ocvalue = [BlockImp new];
            break;
        case OCValueCollectionGetValue:
            ocvalue = [OCCollectionGetValue new];
            break;
        default:
            ocvalue = [OCValue new];
            break;
    }
    ocvalue.value_type = type;
    ocvalue.value = value;
    return ocvalue;
}
OCValue *makeValue(OC_VALUE_TYPE type) __attribute__((overloadable)){
    return makeValue(type, nil);
}
UnaryExpression *makeUnaryExpression(UnaryOperatorType type){
    UnaryExpression *expression = [UnaryExpression  new];
    expression.operatorType = type;
    return expression;
}
BinaryExpression *makeBinaryExpression(BinaryOperatorType type)
{
    BinaryExpression *expression = [BinaryExpression new];
    expression.operatorType = type;
    return expression;
}
TernaryExpression *makeTernaryExpression(){
    return [TernaryExpression  new];
}

AssignExpression *makeAssignExpression(AssignOperatorType type){
    AssignExpression *expression = [AssignExpression new];
    expression.assignType = type;
    return expression;
}
extern DeclareExpression *makeDeclareExpression(TypeSpecial *type,Variable *var,id <Expression> exp){
    DeclareExpression *declare = [DeclareExpression new];
    declare.pair = makeTypeVarPair(type, var);
    declare.expression = exp;
    return declare;
}



IfStatement *makeIfStatement(id <Expression> judgement, BlockImp *imp){
    IfStatement *statement = [IfStatement new];
    statement.funcImp = imp;
    statement.condition = judgement;
    return statement;
}
WhileStatement *makeWhileStatement(id <Expression>judgement, BlockImp *imp){
    WhileStatement *statement = [WhileStatement new];
    statement.funcImp = imp;
    statement.condition = judgement;
    return statement;
}
DoWhileStatement *makeDoWhileStatement(id <Expression>judgement, BlockImp *imp){
    DoWhileStatement *statement = [DoWhileStatement new];
    statement.condition = judgement;
    statement.funcImp = imp;
    return statement;
}
CaseStatement *makeCaseStatement(OCValue *value){
    CaseStatement *statement = [CaseStatement new];
    statement.value = value;
    statement.funcImp = [BlockImp new];
    return statement;
}
SwitchStatement *makeSwitchStatement(OCValue *value){
    SwitchStatement *statement = [SwitchStatement new];
    statement.value = value;
    return statement;
}
ForStatement *makeForStatement(BlockImp *imp){
    ForStatement *statement = [ForStatement new];
    statement.funcImp = imp;
    return statement;
}
ForInStatement *makeForInStatement(BlockImp *imp){
    ForInStatement *statement = [ForInStatement new];
    statement.funcImp = imp;
    return statement;
}

ReturnStatement *makeReturnStatement(id <ValueExpression> expression){
    ReturnStatement *statement = [ReturnStatement new];
    statement.expression = expression;
    return statement;
}
BreakStatement *makeBreakStatement(void){
    return [BreakStatement new];
}

ContinueStatement *makeContinueStatement(void){
    return [ContinueStatement new];
}

static NSMutableString *buffer = nil;
void appendCharacter(char chr){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        buffer = [NSMutableString string];
    });
    [buffer appendFormat:@"%c",chr];
}
void appendText(char *text){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        buffer = [NSMutableString string];
    });
    [buffer appendFormat:@"%s",text];
}


NSString * getString(void){
    NSString *string = [buffer copy];
    buffer = [NSMutableString string];
    return string;
}
