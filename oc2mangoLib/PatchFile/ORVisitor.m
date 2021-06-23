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
    switch (node.nodeType) {
        case AstEnumEmptyNode: [self visitEmptyNode:node]; break;
#define TYPE_CHECKE(node_name)\
case AstEnum##node_name: [self visit##node_name:(OR##node_name *)node]; break;
NODE_LIST(TYPE_CHECKE)
#undef TYPE_CHECKE
        default: break;
    }
}
- (void)visitEmptyNode:(ORNode *)node{
    
}
#define METHOD_IMPS(node_name)\
- (void)visit##node_name:(OR##node_name *)node{ }
NODE_LIST(METHOD_IMPS)
#undef METHOD_IMPS

@end
