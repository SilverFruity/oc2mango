//
//  MakeDeclare.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "MakeDeclare.h"
#import "JudgementExpression.h"


ClassDeclare * makeClassDeclare(NSString *className){
    ClassDeclare *declare = [ClassDeclare new];
    declare.className = className;
    declare.properties = [NSMutableArray array];
    declare.protocolNames = [NSMutableArray array];
    declare.privateVariables = [NSMutableArray array];
    declare.methods = [NSMutableArray array];
    return declare;
}

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

ClassImplementation *makeClassImplementation(NSString *className){
    ClassImplementation *imp = [ClassImplementation new];
    imp.className = className;
    imp.privateVariables = [NSMutableArray array];
    imp.methodImps = [NSMutableArray array];
    return imp;
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
OCValue *makeValue(OC_VALUE_TYPE type){
    OCValue *value;
    switch (type){
        case OCValueObject:
        case OCValueSelf:
        case OCValueSuper:
        case OCValueBlock:
        case OCValueDictionary:
        case OCValueArray:
        case OCValueNSNumber:
        case OCValueString:
        case OCValueCString:
        case OCValueNumber:
        case OCValueConvert:
        case OCValueNil:
        case OCValueNULL:
        case OCValuePointValue:
        case OCValueVarPoint:
            value = [OCValue new];
            break;
        case OCValueMethodCall:
            value = [OCMethodCall new];
            break;
    }
    value.value_type = type;
    return value;
}
JudgementExpression *makeJudgementExpression(JudgementOperatorType type)
{
    JudgementExpression *expression = [JudgementExpression new];
    expression.operatorType = type;
    return expression;
}
ControlExpression *makeControlExpression(ControlExpressionType type){
    ControlExpression *expression = [ControlExpression new];
    expression.controlType = type;
    return expression;
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
