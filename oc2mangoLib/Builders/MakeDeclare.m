//
//  MakeDeclare.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "MakeDeclare.h"


TypeSpecial *makeTypeSpecial(SpecialType type ,NSString *name){
    return [TypeSpecial specialWithType:type name:name];
}
TypeSpecial *makeTypeSpecial(SpecialType type) __attribute__((overloadable)){
    return makeTypeSpecial(type, nil);
}

VariableDeclare *makeVariableDeclare(TypeSpecial *type, NSString *name){
    VariableDeclare *var = [VariableDeclare new];
    var.type = type;
    var.name = name;
    return var;
}

MethodDeclare *makeMethodDeclare(BOOL isClassMethod, TypeSpecial *returnType){
    MethodDeclare *method = [MethodDeclare new];
    method.methodNames = [NSMutableArray array];
    method.parameterNames  = [NSMutableArray array];
    method.parameterTypes = [NSMutableArray array];
    method.isClassMethod = isClassMethod;
    method.returnType = returnType;
    return method;
}

FuncDeclare *makeFuncDeclare(TypeSpecial *returnType,NSMutableArray *vars){
    FuncDeclare *decl = [FuncDeclare new];
    decl.returnType = returnType;
    if (vars) {
        assert([vars isKindOfClass:[NSMutableArray class]]);
    }
    decl.variables = vars;
    return decl;
}
MethodImplementation *makeMethodImplementation(MethodDeclare *declare){
    MethodImplementation *imp = [MethodImplementation new];
    imp.declare = declare;
    return imp;
}
extern FunctionImp *makeFuncImp(){
    return [FunctionImp new];
}

extern id <OCMethodElement> makeMethodCallElement(OCMethodCallType type){
    switch (type){
        case OCMethodCallNormalCall:
            return [OCMethodCallNormalElement  new];
        case OCMethodCallDotGet:
            return [OCMethodCallGetElement  new];
    }
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
DeclareExpression *makeDeclareExpression(VariableDeclare *declare){
    DeclareExpression *expression = [DeclareExpression new];
    expression.declare = declare;
    return expression;
}



IfStatement *makeIfStatement(id <Expression> judgement, FunctionImp *imp){
    IfStatement *statement = [IfStatement new];
    statement.funcImp = imp;
    statement.condition = judgement;
    return statement;
}
WhileStatement *makeWhileStatement(id <Expression>judgement, FunctionImp *imp){
    WhileStatement *statement = [WhileStatement new];
    statement.funcImp = imp;
    return statement;
}
DoWhileStatement *makeDoWhileStatement(id <Expression>judgement, FunctionImp *imp){
    DoWhileStatement *statement = [DoWhileStatement new];
    statement.funcImp = imp;
    return statement;
}
extern CaseStatement *makeCaseStatement(OCValue *value){
    CaseStatement *statement = [CaseStatement new];
    statement.value = value;
    return statement;
}
SwitchStatement *makeSwitchStatement(OCValue *value){
    SwitchStatement *statement = [SwitchStatement new];
    statement.value = value;
    return statement;
}
ForStatement *makeForStatement(FunctionImp *imp){
    ForStatement *statement = [ForStatement new];
    statement.funcImp = imp;
    return statement;
}
ForInStatement *makeForInStatement(FunctionImp *imp){
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


void pushFuncSymbolTable(void){
    [OCParser.stack push:[FuncSymbolTable new]];
}
void popFuncSymbolTable(void){
    [OCParser.stack pop];
}
Symbol *lookupSymbol(NSString *name){
    return [OCParser.stack lookup:name];
}
void addVariableSymbol(NSString *name){
    VariableSymbol *sym = [VariableSymbol symbolWithName:name];
    [OCParser.stack addSymbolToLast:sym forKey:name];
}

void addTypeSymbol(NSString *name){
    TypeSymbol *sym = [TypeSymbol symbolWithName:name];
    [OCParser.stack addSymbolToLast:sym forKey:name];
}
