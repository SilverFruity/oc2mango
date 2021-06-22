//
//  ORVisitor.m
//  ORPatchFile
//
//  Created by Jiang on 2021/6/22.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "ORVisitor.h"

@implementation ORVisitor

- (void)visitAllNode:(ORNode *)node {
    if ([node isKindOfClass:[ORNode class]]){ }
#define TYPE_CHECKE(type)\
else if ([node isKindOfClass:[OR##type class]]){ [self visit##type:(OR##type *)node];}
NODE_LIST(TYPE_CHECKE)
#undef TYPE_CHECKE
}

#define METHOD_IMPS(type)\
- (void)visit##type:(OR##type *)node{ }
NODE_LIST(METHOD_IMPS)
#undef METHOD_IMPS

@end
