//
//  Convert.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MakeDeclare.h"
NS_ASSUME_NONNULL_BEGIN
@interface Convert : NSObject
- (NSString *)convert:(id)content;
- (NSString *)convertOCClass:(OCClass *)occlass;
- (NSString *)convertExpression:(id <Expression>)exp;
- (NSString *)convertStatement:(Statement *)statement;

- (NSString *)convertTypeSpecial:(TypeSpecial *)type;
- (NSString *)convertVariableDeclare:(VariableDeclare *)varDecl;
- (NSString *)convertPropertyDeclare:(PropertyDeclare *)propertyDecl;
- (NSString *)convertMethoDeclare:(MethodDeclare *)methodDecl;
- (NSString *)convertMethodImp:(MethodImplementation *)methodImp;
- (NSString *)convertFuncDeclare:(FuncDeclare *)funcDecl;
- (NSString *)convertFuncImp:(FunctionImp *)imp;

- (NSString *)convertAssginExp:(AssignExpression *)exp;
- (NSString *)convertOCValue:(OCValue *)value;

- (NSString *)convertIfStatement:(IfStatement *)statement;
- (NSString *)convertWhileStatement:(WhileStatement *)statement;
- (NSString *)convertDoWhileStatement:(DoWhileStatement *)statement;
- (NSString *)convertSwitchStatement:(SwitchStatement *)statement;
- (NSString *)convertForStatement:(ForStatement *)statement;
- (NSString *)convertForInStatement:(ForInStatement *)statement;
@end
NS_ASSUME_NONNULL_END
