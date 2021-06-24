//
//  AstVisitor.m
//  ORPatchFile
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "AstVisitor.h"

void AstVisitor_VisitNode(id <AstVisitor> visitor, ORNode *node){
    switch (node.nodeType) {
        case AstEnumEmptyNode: [visitor visitEmptyNode:node]; break;
#define TYPE_CHECKE(node_name)\
case AstEnum##node_name: [visitor visit##node_name:(OR##node_name *)node]; break;
NODE_LIST(TYPE_CHECKE)
#undef TYPE_CHECKE
        default: break;
    }
}
