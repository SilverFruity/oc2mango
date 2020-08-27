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
- (NSString *)convert:(id)node;
- (NSString *)convertOCClass:(ORClass *)occlass;

- (NSString *)convertTypeSpecial:(ORTypeSpecial *)type;
- (NSString *)convertPropertyDeclare:(ORPropertyDeclare *)propertyDecl;
- (NSString *)convertMethoDeclare:(ORMethodDeclare *)methodDecl;
- (NSString *)convertMethodImp:(ORMethodImplementation *)methodImp;
- (NSString *)convertFuncDeclare:(ORFuncDeclare *)funcDecl;

- (NSString *)convertAssginExp:(ORAssignExpression *)exp;
- (NSString *)convertOCValue:(ORValueExpression *)value;

- (NSString *)convertIfStatement:(ORIfStatement *)statement;
- (NSString *)convertWhileStatement:(ORWhileStatement *)statement;
- (NSString *)convertDoWhileStatement:(ORDoWhileStatement *)statement;
- (NSString *)convertSwitchStatement:(ORSwitchStatement *)statement;
- (NSString *)convertForStatement:(ORForStatement *)statement;
- (NSString *)convertForInStatement:(ORForInStatement *)statement;
@end
NS_ASSUME_NONNULL_END
