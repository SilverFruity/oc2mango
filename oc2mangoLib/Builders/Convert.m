//
//  Convert.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Convert.h"
#import "MakeDeclare.h"
@implementation Convert
- (NSString *)convert:(id)content{
    if ([content isKindOfClass:[OCClass class]]) {
        return [self convertOCClass:content];
    }else if ([content conformsToProtocol:@protocol(Expression)]){
        return [self convertExpression:content];
    }else if ([content isKindOfClass:[Statement class]]){
        return [self convertStatement:content];
    }else if ([content isKindOfClass:[MethodImplementation class]]){
        return [self convertMethodImp:content];
    }
    NSAssert(NO, @"%s %d ",__FILE__,__LINE__);
    return @"";
}
- (NSString *)convertOCClass:(OCClass *)occlass{
    NSMutableString *content = [NSMutableString string];
    [content appendFormat:@"class %@:%@",occlass.className,occlass.superClassName];
    [content appendString:@"{\n"];
    for (PropertyDeclare *prop in occlass.properties) {
        [content appendString:[self convertPropertyDeclare:prop]];
    }
    for (MethodImplementation *imp in occlass.methods) {
        [content appendString:[self convertMethodImp:imp]];
    }
    [content appendString:@"\n}\n"];
    return content;
}
- (NSString *)convertExpression:(id <Expression>)exp{
    if ([exp isKindOfClass:[AssignExpression class]]) {
        return [self convertAssginExp:exp];
    }else if ([exp isKindOfClass:[CalculateExpression class]]){
        return [self convertCalculateExp:exp];
    }else if ([exp isKindOfClass:[ControlExpression class]]){
        return [self convertControlExp:exp];
    }else if ([exp isKindOfClass:[JudgementExpression class]]){
        return [self convertJudgementExp:exp];
    }else if ([exp isKindOfClass:[OCValue class]]){
        return [self convertOCValue:exp];
    }
    return @"";
}
- (NSString *)convertStatement:(Statement *)statement{
    if ([Statement isKindOfClass:[IfStatement class]]) {
        return [self convertIfStatement:statement];
    }else if([statement isKindOfClass:[WhileStatement class]]){
        return [self convertWhileStatement:statement];
    }else if([statement isKindOfClass:[DoWhileStatement class]]){
        return [self convertDoWhileStatement:statement];
    }else if([statement isKindOfClass:[DoWhileStatement class]]){
        return [self convertDoWhileStatement:statement];
    }else if([statement isKindOfClass:[SwitchStatement class]]){
        return [self convertSwitchStatement:statement];
    }else if([statement isKindOfClass:[ForStatement class]]){
        return [self convertForStatement:statement];
    }else if([statement isKindOfClass:[ForInStatement class]]){
        return [self convertForInStatement:statement];
    }
    return @"";
}

- (NSString *)convertTypeSpecial:(TypeSpecial *)typeSpecial{
    NSMutableString *result = [NSMutableString string];
    switch (typeSpecial.type){
        case SpecialTypeUChar:
        case SpecialTypeUShort:
        case SpecialTypeUInt:
        case SpecialTypeULong:
        case SpecialTypeULongLong:
            [result appendString:@"uint"]; break;
        case SpecialTypeChar:
        case SpecialTypeShort:
        case SpecialTypeInt:
        case SpecialTypeLong:
        case SpecialTypeLongLong:
            [result appendString:@"int"]; break;
        case SpecialTypeDouble:
        case SpecialTypeFloat:
            [result appendString:@"double"]; break;
        case SpecialTypeVoid:
            [result appendString:@"void"]; break;
        case SpecialTypeSEL:
            [result appendString:@"SEL"]; break;
        case SpecialTypeClass:
            [result appendString:@"Class"]; break;
        case SpecialTypeBOOL:
            [result appendString:@"BOOL"]; break;
        case SpecialTypeId:
            [result appendString:@"id"]; break;
        case SpecialTypeObject:
            [result appendString:typeSpecial.name]; break;
        case SpecialTypeBlock:
            [result appendString:@"Block"]; break;
        default:
            [result appendString:@"UnknownType"]; break;
    }
    if (typeSpecial.isPointer) {
        [result appendString:@" *"];
    }else{
        [result appendString:@" "];
    }
    return result;
}
- (NSString *)convertVariableDeclare:(VariableDeclare *)varDecl{
    return [NSString stringWithFormat:@"%@%@",[self convertTypeSpecial:varDecl.type],varDecl.name];;
}
- (NSString *)convertPropertyDeclare:(PropertyDeclare *)propertyDecl{
    return @"";
}
- (NSString *)convertMethoDeclare:(MethodDeclare *)methodDecl{
    return @"";
}
- (NSString *)convertMethodImp:(MethodImplementation *)methodImp{
    return @"";
}
- (NSString *)convertFuncDeclare:(FuncDeclare *)funcDecl{
    return @"";
}


- (NSString *)convertFuncImp:(FunctionImp *)imp{
    NSMutableString *content = [NSMutableString string];
    [content appendString:@"\n{\n"];
    for (id statement in imp.statements) {
        if ([statement conformsToProtocol:@protocol(Expression)]) {
            [content appendFormat:@"%@\n",[self convertExpression:statement]];
        }else if ([statement isKindOfClass:[Statement class]]){
            [content appendFormat:@"%@\n",[self convertStatement:statement]];
        }
    }
    [content appendString:@"\n}"];
    return content;
}


- (NSString *)convertAssginExp:(AssignExpression *)exp{
    if ([exp isKindOfClass:[DeclareAssignExpression class]]) {
        DeclareAssignExpression *declExp = exp;
        if (declExp.expression) {
            return [NSString stringWithFormat:@"%@=%@",[self convertVariableDeclare:declExp.declare],[self convertExpression:declExp.expression]];
        }else{
            return [NSString stringWithFormat:@"%@",[self convertVariableDeclare:declExp.declare]];
        }
    }else if ([exp isKindOfClass:[VariableAssignExpression class]]){
        VariableAssignExpression *varExp = exp;
        NSString *operator = @"=";
        return [NSString stringWithFormat:@"%@%@%@",[self convertOCValue:varExp.value],operator,[self convertExpression:varExp.expression]];
    }
    return @"";
}
- (NSString *)convertCalculateExp:(CalculateExpression *)exp{
    return @"";
}
- (NSString *)convertControlExp:(ControlExpression *)exp{
    return @"";
}
- (NSString *)convertJudgementExp:(JudgementExpression *)exp{
    return @"";
}
- (NSString *)convertOCValue:(OCValue *)value{
    return @"";
}

- (NSString *)convertIfStatement:(IfStatement *)statement{
    return @"";
}
- (NSString *)convertWhileStatement:(WhileStatement *)statement{
    NSMutableString *content = [NSMutableString string];
    [content appendFormat:@"while(%@)\n",[self convertExpression:statement.condition]];
    [content appendString:[self convertFuncImp:statement.funcImp]];
    return content;
}
- (NSString *)convertDoWhileStatement:(DoWhileStatement *)statement{
    return @"";
}
- (NSString *)convertSwitchStatement:(SwitchStatement *)statement{
    return @"";
}
- (NSString *)convertForStatement:(ForStatement *)statement{
    return @"";
}
- (NSString *)convertForInStatement:(ForInStatement *)statement{
    return @"";
}
@end
