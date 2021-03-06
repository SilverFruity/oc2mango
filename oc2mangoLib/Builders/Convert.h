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
- (NSString *)convertOCClass:(ORClassNode *)occlass;

- (NSString *)convertTypeNode:(ORDeclaratorNode *)type;
- (NSString *)convertPropertyDeclare:(ORPropertyNode *)propertyDecl;
- (NSString *)convertMethoDeclare:(ORMethodDeclNode *)methodDecl;
- (NSString *)convertMethodImp:(ORMethodNode *)methodImp;
- (NSString *)convertFuncDeclare:(ORFunctionDeclNode *)funcDecl;

- (NSString *)convertAssginExp:(ORAssignExpression *)exp;
- (NSString *)convertOCValue:(ORValueNode *)value;

- (NSString *)convertIfStatement:(ORIfStatement *)statement;
- (NSString *)convertWhileStatement:(ORWhileStatement *)statement;
- (NSString *)convertDoWhileStatement:(ORDoWhileStatement *)statement;
- (NSString *)convertSwitchStatement:(ORSwitchStatement *)statement;
- (NSString *)convertForStatement:(ORForStatement *)statement;
- (NSString *)convertForInStatement:(ORForInStatement *)statement;
@end
NS_ASSUME_NONNULL_END
