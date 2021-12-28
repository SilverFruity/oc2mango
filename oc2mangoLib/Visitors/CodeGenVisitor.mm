//
//  CodeGenVisitor.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "CodeGenVisitor.h"
#import "SymbolTableVisitor.h"
#import <string>
#import <list>
using namespace std;
@implementation CodeGenVisitor

- (void)visit:(nonnull ORNode *)node {
    AstVisitor_VisitNode(self, node);
}

- (void)visitAssignNode:(nonnull ORAssignNode *)node {
    
}

- (void)visitBinaryNode:(nonnull ORBinaryNode *)node {
    
}

- (void)visitBlockNode:(nonnull ORBlockNode *)node {
    
}

- (void)visitBoolValue:(nonnull ORBoolValue *)node {
    
}

- (void)visitCArrayDeclNode:(nonnull ORCArrayDeclNode *)node {
    
}

- (void)visitCaseStatement:(nonnull ORCaseStatement *)node {
    
}

- (void)visitClassNode:(nonnull ORClassNode *)node {
    
}

- (void)visitControlStatNode:(nonnull ORControlStatNode *)node {
    
}

- (void)visitDeclaratorNode:(nonnull ORDeclaratorNode *)node {
    
}

- (void)visitDoWhileStatement:(nonnull ORDoWhileStatement *)node {
    
}

- (void)visitDoubleValue:(nonnull ORDoubleValue *)node {
    
}

- (void)visitEnumStatNode:(nonnull OREnumStatNode *)node {
    
}

- (void)visitForInStatement:(nonnull ORForInStatement *)node {
    
}

- (void)visitForStatement:(nonnull ORForStatement *)node {
    
}

- (void)visitFunctionCall:(nonnull ORFunctionCall *)node {
    
}

- (void)visitFunctionDeclNode:(nonnull ORFunctionDeclNode *)node {
    
}

- (void)visitFunctionNode:(nonnull ORFunctionNode *)node {
    
}

- (void)visitIfStatement:(nonnull ORIfStatement *)node {
    
}

- (void)visitInitDeclaratorNode:(nonnull ORInitDeclaratorNode *)node {
    
}

- (void)visitIntegerValue:(nonnull ORIntegerValue *)node {
    
}

- (void)visitMethodCall:(nonnull ORMethodCall *)node {
    
}

- (void)visitMethodDeclNode:(nonnull ORMethodDeclNode *)node {
    
}

- (void)visitMethodNode:(nonnull ORMethodNode *)node {
    
}

- (void)visitPropertyNode:(nonnull ORPropertyNode *)node {
    
}

- (void)visitProtocolNode:(nonnull ORProtocolNode *)node {
    
}

- (void)visitStructStatNode:(nonnull ORStructStatNode *)node {
    
}

- (void)visitSubscriptNode:(nonnull ORSubscriptNode *)node {
    
}

- (void)visitSwitchStatement:(nonnull ORSwitchStatement *)node {
    
}

- (void)visitTernaryNode:(nonnull ORTernaryNode *)node {
    
}

- (void)visitTypeNode:(nonnull ORTypeNode *)node {
    
}

- (void)visitTypedefStatNode:(nonnull ORTypedefStatNode *)node {
    
}

- (void)visitUIntegerValue:(nonnull ORUIntegerValue *)node {
    
}

- (void)visitUnaryNode:(nonnull ORUnaryNode *)node {
    
}

- (void)visitUnionStatNode:(nonnull ORUnionStatNode *)node {
    
}

- (void)visitValueNode:(nonnull ORValueNode *)node {
    
}

- (void)visitVariableNode:(nonnull ORVariableNode *)node {
    
}

- (void)visitWhileStatement:(nonnull ORWhileStatement *)node {
    
}

- (void)visitEmptyNode:(nonnull ORNode *)node {
    
}





@end
