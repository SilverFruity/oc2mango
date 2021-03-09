//
//  Env.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/3/8.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "Env.h"
#import <ORPatchFile/RunnerClasses.h>
static Env *topEnv = nil;
static Env *savedEnv = nil;
void pushEnv(void){
    savedEnv = topEnv;
    Env *cur = [Env new];
    cur.prev = savedEnv;
    topEnv = cur;
}
void popEnv(void){
    topEnv = savedEnv;
    savedEnv = nil;
}
void EnvAddDecl(ORDeclaratorNode *decl){
    [topEnv addDecl:decl];
}
@interface Env()
@property (nonatomic, strong)NSMutableDictionary <NSString *, ORDeclaratorNode *> *symbolTable;
@end
@implementation Env
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.symbolTable = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)addDecl:(ORDeclaratorNode *)decl{
    self.symbolTable[decl.var.varname] = decl;
}
- (ORDeclaratorNode *)declForVarname:(NSString *)name{
    if (name == nil) {
        return nil;
    }
    return self.symbolTable[name];
}
- (ORDeclaratorNode *)declForVarName:(NSString *)varname{
    for (Env *cur = self; cur != nil; cur = cur.prev) {
        ORDeclaratorNode *node = [cur declForVarname:varname];
        if (node != nil) return node;
    }
    return nil;
}
@end
