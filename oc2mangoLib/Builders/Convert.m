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
    }
    NSAssert(NO, @"%s %d ",__FILE__,__LINE__);
    return @"";
}
- (NSString *)convertOCClass:(OCClass *)occlass{
    NSMutableString *content = [NSMutableString string];
    [content appendFormat:@"class %@:%@",occlass.className,occlass.superClassName];
    if (occlass.protocols.count > 0) {
        [content appendFormat:@"<%@>",[occlass.protocols componentsJoinedByString:@","]];
    }
    [content appendString:@"{\n"];
    for (PropertyDeclare *prop in occlass.properties) {
        [content appendString:[self convertPropertyDeclare:prop]];
    }
    for (MethodImplementation *imp in occlass.methods) {
        [content appendString:[self convertMethodImp:imp]];
    }
    [content appendString:@"\n}"];
    return content;
}
- (NSString *)convertExpression:(id <Expression>)exp{
    if ([exp isKindOfClass:[DeclareExpression class]]) {
        return [self convertDeclareExp:exp];
    }else if ([exp isKindOfClass:[AssignExpression class]]) {
        return [self convertAssginExp:exp];
    }else if ([exp isKindOfClass:[OCValue class]]){
        return [self convertOCValue:(OCValue *)exp];
    }else if ([exp isKindOfClass:[BinaryExpression class]]){
        return [self convertBinaryExp:(BinaryExpression *)exp];
    }else if ([exp isKindOfClass:[UnaryExpression class]]){
        return [self convertUnaryExp:(UnaryExpression *)exp];
    }else if ([exp isKindOfClass:[TernaryExpression class]]){
        return [self convertTernaryExp:(TernaryExpression *)exp];
    }
    return @"";
}
- (NSString *)convertStatement:(Statement *)statement{
    if ([statement isKindOfClass:[IfStatement class]]) {
        return [self convertIfStatement:(IfStatement *) statement];
    }else if([statement isKindOfClass:[WhileStatement class]]){
        return [self convertWhileStatement:(WhileStatement *) statement];
    }else if([statement isKindOfClass:[DoWhileStatement class]]){
        return [self convertDoWhileStatement:(DoWhileStatement *) statement];
    }else if ([statement isKindOfClass:[SwitchStatement class]]) {
        return [self convertSwitchStatement:(SwitchStatement *) statement];
    } else if ([statement isKindOfClass:[ForStatement class]]) {
        return [self convertForStatement:(ForStatement *) statement];
    } else if ([statement isKindOfClass:[ForInStatement class]]) {
        return [self convertForInStatement:(ForInStatement *) statement];
    } else if ([statement isKindOfClass:[ReturnStatement class]]) {
        return [self convertReturnStatement:(ReturnStatement *) statement];
    } else if ([statement isKindOfClass:[BreakStatement class]]) {
        return [self convertBreakStatement:(BreakStatement *) statement];
    } else if ([statement isKindOfClass:[ContinueStatement class]]) {
        return [self convertContinueStatement:(ContinueStatement *) statement];
    }
    return @"";
}

- (NSString *)convertTypeSpecial:(TypeSpecial *)typeSpecial{
    NSMutableString *result = [NSMutableString string];
    switch (typeSpecial.type){
        case TypeUChar:
        case TypeUShort:
        case TypeUInt:
        case TypeULong:
        case TypeULongLong:
            [result appendString:@"uint"]; break;
        case TypeChar:
        case TypeShort:
        case TypeInt:
        case TypeLong:
        case TypeLongLong:
            [result appendString:@"int"]; break;
        case TypeDouble:
        case TypeFloat:
            [result appendString:@"double"]; break;
        case TypeVoid:
            [result appendString:@"void"]; break;
        case TypeSEL:
            [result appendString:@"SEL"]; break;
        case TypeClass:
            [result appendString:@"Class"]; break;
        case TypeBOOL:
            [result appendString:@"BOOL"]; break;
        case TypeId:
            [result appendString:@"id"]; break;
        case TypeObject:
            [result appendString:typeSpecial.name]; break;
        case TypeBlock:
            [result appendString:@"Block"]; break;
        
        case TypeEnum:
            [result appendString:@"int"]; break;
            break;
        case TypeLongDouble:
            [result appendString:@"double"]; break;
            break;
        case TypeStruct:
            [result appendString:typeSpecial.name]; break;
            break;
        case TypeFunction:
            [result appendString:typeSpecial.name]; break;
            break;
        default:
            [result appendString:@"UnKnownType"];
            break;
    }
    [result appendString:@" "];

    return result;
}

- (NSString *)convertPropertyDeclare:(PropertyDeclare *)propertyDecl{
    
    return [NSString stringWithFormat:@"@property(%@)%@;",[propertyDecl.keywords componentsJoinedByString:@","],[self convertTypeVarPair:propertyDecl.var]];
    return @"";
}
- (NSString *)convertMethoDeclare:(MethodDeclare *)methodDecl{
    NSString *methodName = @"";
    if (methodDecl.parameterNames.count == 0) {
        methodName = methodDecl.methodNames.firstObject;
    }else{
        NSMutableArray *list = [NSMutableArray array];
        for (int i = 0; i < methodDecl.parameterNames.count; i++) {
            [list addObject:[NSString stringWithFormat:@"%@:(%@)%@",methodDecl.parameterNames[i],[self convertTypeVarPair:methodDecl.parameterTypes[i]],methodDecl.parameterNames[i]]];
        }
        methodName = [list componentsJoinedByString:@" "];
    }
    return [NSString stringWithFormat:@"%@(%@)%@",methodDecl.isClassMethod?@"+":@"-",[self convertTypeVarPair:methodDecl.returnType],methodName];
}
- (NSString *)convertMethodImp:(MethodImplementation *)methodImp{
    return [NSString stringWithFormat:@"\n%@%@",[self convertMethoDeclare:methodImp.declare],[self convertBlockImp:methodImp.imp]];
}
- (NSString *)convertFuncDeclare:(FuncDeclare *)funcDecl{
    return [NSString stringWithFormat:@"%@%@",[self convertTypeVarPair:funcDecl.returnType],[self convertVariable:funcDecl.var]];;
}

int indentationCont = 0;
- (NSString *)convertBlockImp:(BlockImp *)imp{
    NSMutableString *content = [NSMutableString string];
    if (imp.declare) {
        if (imp.declare.var.ptCount > 0) {
            // void x(int y){ }
            [content appendFormat:@"%@", [self convertFuncDeclare:imp.declare]];
        }else{
            // ^void (int x){ }
            [content appendFormat:@"^%@", [self convertFuncDeclare:imp.declare]];
        }
    }
    indentationCont++;
    [content appendString:@"{\n"];
    NSMutableString *tabs = [@"" mutableCopy];
    for (int i = 0; i < indentationCont - 1; i++) {
        [tabs appendString:@"    "];
    }
    for (id statement in imp.statements) {
        if ([statement conformsToProtocol:@protocol(Expression)]) {
            [content appendFormat:@"%@    %@;\n",tabs,[self convertExpression:statement]];
        }else if ([statement isKindOfClass:[Statement class]]){
            [content appendFormat:@"%@    %@\n",tabs,[self convertStatement:statement]];
        }
    }
    [content appendFormat:@"%@}",tabs];
    indentationCont--;
    return content;
    return @"";
}
- (NSString *)convertBinaryExp:(BinaryExpression *)exp{
    NSString *operator = @"";
    switch (exp.operatorType) {
        case BinaryOperatorAdd:
            operator = @"+";
            break;
        case BinaryOperatorSub:
            operator = @"-";
            break;
        case BinaryOperatorDiv:
            operator = @"/";
            break;
        case BinaryOperatorMulti:
            operator = @"*";
            break;
        case BinaryOperatorMod:
            operator = @"%";
            break;
        case BinaryOperatorShiftLeft:
            operator = @"<<";
            break;
        case BinaryOperatorShiftRight:
            operator = @">>";
            break;
        case BinaryOperatorAnd:
            operator = @"&";
            break;
        case BinaryOperatorOr:
            operator = @"|";
            break;
        case BinaryOperatorXor:
            operator = @"^";
            break;
        case BinaryOperatorLT:
            operator = @"<";
            break;
        case BinaryOperatorGT:
            operator = @">";
            break;
        case BinaryOperatorLE:
            operator = @"<=";
            break;
        case BinaryOperatorGE:
            operator = @">=";
            break;
        case BinaryOperatorNotEqual:
            operator = @"!=";
            break;
        case BinaryOperatorEqual:
            operator = @"==";
            break;
        case BinaryOperatorLOGIC_AND:
            operator = @"||";
            break;
        case BinaryOperatorLOGIC_OR:
            operator = @"&&";
            break;
    }
    return [NSString stringWithFormat:@"%@ %@ %@",[self convertExpression:exp.left],operator,[self convertExpression:exp.right]];
}
- (NSString *)convertUnaryExp:(UnaryExpression *)exp{
    NSString *format = @"%@";
    switch (exp.operatorType) {
        
        case UnaryOperatorIncrementSuffix:
            format = @"%@++";
            break;
        case UnaryOperatorDecrementSuffix:
            format = @"%@--";
            break;
        case UnaryOperatorIncrementPrefix:
            format = @"++%@";
            break;
        case UnaryOperatorDecrementPrefix:
            format = @"--%@";
            break;
        case UnaryOperatorNot:
            format = @"!%@";
            break;
        case UnaryOperatorNegative:
            format = @"-%@";
            break;
        case UnaryOperatorBiteNot:
            format = @"-%@";
            break;
        case UnaryOperatorSizeOf:
            format = @"~%@";
            break;
        case UnaryOperatorAdressPoint:
            format = @"&%@";
            break;
        case UnaryOperatorAdressValue:
            format = @"*%@";
            break;
    }
    return [NSString stringWithFormat:format,[self convertExpression:exp.value]];
}
- (NSString *)convertTernaryExp:(TernaryExpression *)exp{
    if (exp.values.count == 1) {
        return [NSString stringWithFormat:@"%@ ?: %@",[self convertExpression:exp.expression],[self convertExpression:exp.values.firstObject]];
    }else{
        return [NSString stringWithFormat:@"%@ ? %@ : %@",[self convertExpression:exp.expression],[self convertExpression:exp.values.firstObject],[self convertExpression:exp.values.lastObject]];
    }
}
- (NSString *)convertDeclareExp:(DeclareExpression *)exp{
    if (exp.expression) {
        return [NSString stringWithFormat:@"%@%@ = %@",[self convertTypeSpecial:exp.type],[self convertVariable:exp.var],[self convertExpression:exp.expression]];
    }else{
        return [NSString stringWithFormat:@"%@%@",[self convertTypeSpecial:exp.type],[self convertVariable:exp.var]];
    }
    return @"";
}
- (NSString *)convertAssginExp:(AssignExpression *)exp{
    NSString *operator = @"=";
    return [NSString stringWithFormat:@"%@ %@ %@",[self convertOCValue:exp.value],operator,[self convertExpression:exp.expression]];
}

- (NSString *)convertOCValue:(OCValue *)value{
    switch (value.value_type){
        case OCValueClassType:
        case OCValueSelector:
        case OCValueInt:
        case OCValueDouble:
        case OCValueConvert:
        case OCValueVariable:
            return value.value;
            
        case OCValueSelf:
            return @"self";
        case OCValueSuper:
            return @"super";

        case OCValueString:
            return [NSString stringWithFormat:@"@\"%@\"",value.value];
        case OCValueCString:
            return [NSString stringWithFormat:@"\"%@\"",value.value];
        case OCValueProtocol:
            return [NSString stringWithFormat:@"@protocol(%@)",value.value];
        case OCValueDictionary:
        {
            NSMutableArray <NSMutableArray *>*keyValuePairs = value.value;
            NSMutableArray *pairs = [NSMutableArray array];
            for (NSMutableArray *keyValue in keyValuePairs) {
                [pairs addObject:[NSString stringWithFormat:@"%@:%@",[self convertExpression:keyValue[0]],[self convertExpression:keyValue[1]]]];
            }
            return [NSString stringWithFormat:@"@{%@}",[pairs componentsJoinedByString:@","]];
        }
        case OCValueArray:{
            NSMutableArray *exps = value.value;
            NSMutableArray *elements = [NSMutableArray array];
            for (id <Expression> exp in exps) {
                [elements addObject:[self convertExpression:exp]];
            }
            return [NSString stringWithFormat:@"@[%@]",[elements componentsJoinedByString:@","]];
        }
        case OCValueNSNumber:
            return [NSString stringWithFormat:@"@(%@)",value.value];

        case OCValueBlock:
        {
            return [self convertBlockImp:(BlockImp *)value];
        }
        case OCValueNil:
            return @"nil";
        case OCValueNULL:
            return @"NULL";
        case OCValuePointValue:
            return [NSString stringWithFormat:@"*%@",value.value];
        case OCValueVarPoint:
            return [NSString stringWithFormat:@"&%@",value.value];
        case OCValueMethodCall:
            return [self convertOCMethodCall:(OCMethodCall *) value];
        case OCValueFuncCall:{
            return [self convertFunCall:(CFuncCall *)value];
        }
        case OCValueCollectionGetValue:
        {
            OCCollectionGetValue *collection = (OCCollectionGetValue *)value;
            return [NSString stringWithFormat:@"%@[%@]",[self convertExpression:collection.caller],[self convertExpression:collection.keyExp]];
        }
    }
    return @"";
}
- (NSString *)convertFunCall:(CFuncCall *)call{
    return [NSString stringWithFormat:@"%@(%@)",[self convertExpression:call.caller],[self convertExpressionList:call.expressions]];
}
- (NSString *)convertOCMethodCall:(OCMethodCall *)call{
    NSMutableString *methodName = [[call.names componentsJoinedByString:@":"] mutableCopy];
    NSString *sel;
    if (call.values.count == 0) {
        if (call.isDot) {
            sel = [NSString stringWithFormat:@".%@",methodName];
        }else{
            sel = [NSString stringWithFormat:@".%@()",methodName];
        }
    }else{
        sel = [NSString stringWithFormat:@".%@:(%@)",methodName,[self convertExpressionList:call.values]];
    }
    return [NSString stringWithFormat:@"%@%@",[self convertExpression:call.caller],sel];
}
- (NSString *)convertIfStatement:(IfStatement *)statement{
    NSString *content = @"";
    while (statement.last) {
        if (!statement.condition) {
           content = [NSString stringWithFormat:@"%@else%@",content,[self convertBlockImp:statement.funcImp]];
        }else{
           content = [NSString stringWithFormat:@"else if(%@)%@%@",[self convertExpression:statement.condition],[self convertBlockImp:statement.funcImp],content];
        }
        statement = statement.last;
    }
    content = [NSString stringWithFormat:@"if(%@)%@%@",[self convertExpression:statement.condition],[self convertBlockImp:statement.funcImp],content];
    return content;
}
- (NSString *)convertWhileStatement:(WhileStatement *)statement{
    NSMutableString *content = [NSMutableString string];
    [content appendFormat:@"while(%@)",[self convertExpression:statement.condition]];
    [content appendString:[self convertBlockImp:statement.funcImp]];
    return content;
}
- (NSString *)convertDoWhileStatement:(DoWhileStatement *)statement{
    return [NSString stringWithFormat:@"do%@while(%@)",[self convertBlockImp:statement.funcImp],[self convertExpression:statement.condition]];
}
- (NSString *)convertSwitchStatement:(SwitchStatement *)statement{
    return [NSString stringWithFormat:@"switch(%@){\n%@}",[self convertExpression:statement.value],[self convertCaseStatements:statement.cases]];
}
- (NSString *)convertCaseStatements:(NSArray *)cases{
    NSMutableString *content = [NSMutableString string];
    for (CaseStatement *statement in cases) {
        if (statement.value) {
            [content appendFormat:@"case %@:%@\n",[self convertExpression:statement.value],[self convertBlockImp:statement.funcImp]];
        }else{
            [content appendFormat:@"default:%@\n",[self convertBlockImp:statement.funcImp]];
        }
    }
    return content;
}
- (NSString *)convertForStatement:(ForStatement *)statement{
    NSMutableString *content = [@"for (" mutableCopy];
    [content appendFormat:@"%@; ",[self convertExpressionList:statement.declareExpressions]];
    [content appendFormat:@"%@; ",[self convertExpression:statement.condition]];
    [content appendFormat:@"%@)",[self convertExpressionList:statement.expressions]];
    [content appendFormat:@"%@",[self convertBlockImp:statement.funcImp]];
    return content;
}
- (NSString *)convertForInStatement:(ForInStatement *)statement{
    return [NSString stringWithFormat:@"for (%@ in %@)%@",[self convertDeclareExp:statement.expression],[self convertExpression:statement.value],[self convertBlockImp:statement.funcImp]];
}
- (NSString *)convertReturnStatement:(ReturnStatement *)statement{
    return [NSString stringWithFormat:@"return %@;",[self convertExpression:statement.expression]];
}
- (NSString *)convertBreakStatement:(BreakStatement *) statement{
    return @"break;";
}
- (NSString *)convertContinueStatement:(ContinueStatement *) statement{
    return @"continue;";
}
- (NSString * )convertExpressionList:(NSArray *)list{    
    NSMutableArray *array = [NSMutableArray array];
    for (id <Expression> exp in list){
        [array addObject:[self convertExpression:exp]];
    }
    return [array componentsJoinedByString:@","];
}
- (NSString *)convertVariable:(Variable *)var{
    NSMutableString *result = [@"" mutableCopy];
    for (int i = 0; i < var.ptCount; i++) {
        [result appendString:@"*"];
    }
    if ([var isKindOfClass:[FuncVariable class]]) {
        FuncVariable *funVar = (FuncVariable *)var;
        if (funVar.pairs.count > 0){
            if (funVar.varname) {
                [result appendFormat:@"%@(%@)",funVar.varname,[self convertTypeVarPairs:funVar.pairs]];
            }else{
                [result appendFormat:@"(%@)",[self convertTypeVarPairs:funVar.pairs]];
            }
        } else{
            [result appendFormat:@"%@()",funVar.varname];
        }
    }else if (var.varname){
        [result appendString:var.varname];
    }

    return result;
}
- (NSString *)convertTypeVarPair:(TypeVarPair *)pair{
    NSString *type = pair.type ? [self convertTypeSpecial:pair.type] : @"void ";
    return [NSString stringWithFormat:@"%@%@",type,[self convertVariable:pair.var]];;
}
- (NSString *)convertTypeVarPairs:(NSArray *)list{
    NSMutableArray *array = [NSMutableArray array];
    for (TypeVarPair * pair in list){
        [array addObject:[self convertTypeVarPair:pair]];
    }
    return [array componentsJoinedByString:@","];
}
- (NSString * )convertTypeSpecailList:(NSArray *)list{
    NSMutableArray *array = [NSMutableArray array];
    for (TypeSpecial * special in list){
        [array addObject:[self convertTypeSpecial:special]];
    }
    return [array componentsJoinedByString:@","];
}

@end
