//
//  MakeDeclare.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassDeclare.h"
#import "ClassImplementation.h"
#import "OCValue.h"
#import "JudgementExpression.h"
#import "ControlExpression.h"
#import "CalculateExpression.h"
#import "AssignExpression.h"



ClassDeclare * makeClassDeclare(NSString *className);

extern TypeSpecial *makeTypeSpecial(SpecialType type, NSString *name);
extern TypeSpecial *makeTypeSpecial(SpecialType type) __attribute__((overloadable)) ;

extern VariableDeclare *makeVariableDeclare(TypeSpecial *type, NSString *name);

extern MethodDeclare *makeMethodDeclare(BOOL isClassMethod, TypeSpecial *returnType);
extern ClassImplementation *makeClassImplementation(NSString *className);
extern MethodImplementation *makeMethodImplementation(MethodDeclare *declare);
extern FunctionImp *makeFuncImp();
extern id <OCMethodElement> makeMethodCallElement(OCMethodCallType type);
extern OCValue *makeValue(OC_VALUE_TYPE type);
extern JudgementExpression *makeJudgementExpression(JudgementOperatorType type);
extern ControlExpression *makeControlExpression(ControlExpressionType type);
extern UnaryExpression *makeUnaryExpression(UnaryOperatorType type);
extern BinaryExpression *makeBinaryExpression(BinaryOperatorType type);
extern TernaryExpression *makeTernaryExpression();
