//
//  Env.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/3/8.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ORDeclaratorNode;
void pushEnv(void);
void popEnv(void);
void EnvAddDecl(ORDeclaratorNode *decl);
@interface Env : NSObject
@property (nullable, strong)Env *prev;
- (ORDeclaratorNode *)declForVarName:(NSString *)varname;
- (void)addDecl:(ORDeclaratorNode *)decl;
- (ORDeclaratorNode *)declForVarname:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
