//
//  AstClasses+Visitor.m
//  ORPatchFile
//
//  Created by Jiang on 2022/11/24.
//  Copyright © 2022 SilverFruity. All rights reserved.
//

#import "AstVisitor.h"
#import "RunnerClasses.h"

@implementation NSArray (AstVisitor)
- (void)accept:(id<AstVisitor>)visitor {
    for (ORNode *node in self) {
        [node accept:visitor];
    }
}
@end

@implementation ORNode (Visitor)
- (void)accept:(id)visitor {
    [visitor visit:self];
}
@end

@implementation ORTypeNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitTypeNode:self];
}
@end

@implementation ORVariableNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitVariableNode:self];
}
@end

@implementation ORDeclaratorNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitDeclaratorNode:self];
    [self.type accept:visitor];
    [self.var accept:visitor];
}
@end

@implementation ORFunctionDeclNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitFunctionDeclNode:self];
    [self.type accept:visitor];
    [self.var accept:visitor];
    [self.params accept:visitor];
}
@end

@implementation ORCArrayDeclNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitCArrayDeclNode:self];
    [self.type accept:visitor];
    [self.var accept:visitor];
    [self.capacity accept:visitor];
}
@end

@implementation ORBlockNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitBlockNode:self];
    [self.statements accept:visitor];
}
@end

@implementation ORValueNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitValueNode:self];
    if ([self.value isKindOfClass:[ORNode class]]) {
        [self.value accept:visitor];
    }
}
@end

@implementation ORIntegerValue (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitIntegerValue:self];
}
@end

@implementation ORUIntegerValue (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitUIntegerValue:self];
}
@end

@implementation ORDoubleValue (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitDoubleValue:self];
}
@end

@implementation ORBoolValue (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitBoolValue:self];
}
@end

@implementation ORMethodCall (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitMethodCall:self];
    [self.caller accept:visitor];
    [self.values accept:visitor];
}
@end

@implementation ORFunctionCall (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitFunctionCall:self];
    [self.caller accept:visitor];
    [self.expressions accept:visitor];
}
@end

@implementation ORFunctionNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitFunctionNode:self];
    [self.declare accept:visitor];
    [self.scopeImp accept:visitor];
}
@end

@implementation ORSubscriptNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitSubscriptNode:self];
    [self.caller accept:visitor];
    [self.keyExp accept:visitor];
}
@end

@implementation ORAssignNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitAssignNode:self];
    [self.value accept:visitor];
    [self.expression accept:visitor];
}
@end

@implementation ORInitDeclaratorNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitInitDeclaratorNode:self];
    [self.declarator accept:visitor];
    [self.expression accept:visitor];
}
@end

@implementation ORUnaryNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitUnaryNode:self];
    [self.value accept:visitor];
}
@end

@implementation ORBinaryNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitBinaryNode:self];
    [self.left accept:visitor];
    [self.right accept:visitor];
}
@end

@implementation ORTernaryNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitTernaryNode:self];
    [self.expression accept:visitor];
    [self.values accept:visitor];
}
@end

@implementation ORIfStatement (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitIfStatement:self];
    [self.condition accept:visitor];
    [self.scopeImp accept:visitor];
    [self.statements accept:visitor];
}
@end

@implementation ORWhileStatement (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitWhileStatement:self];
    [self.condition accept:visitor];
    [self.scopeImp accept:visitor];
}
@end

@implementation ORDoWhileStatement (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitDoWhileStatement:self];
    [self.scopeImp accept:visitor];
    [self.condition accept:visitor];
}
@end

@implementation ORCaseStatement (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitCaseStatement:self];
    [self.value accept:visitor];
    [self.scopeImp accept:visitor];
}
@end

@implementation ORSwitchStatement (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitSwitchStatement:self];
    [self.value accept:visitor];
    [self.cases accept:visitor];
}
@end

@implementation ORForStatement (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitForStatement:self];
    [self.varExpressions accept:visitor];
    [self.condition accept:visitor];
    [self.expressions accept:visitor];
    [self.scopeImp accept:visitor];
}
@end

@implementation ORForInStatement (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitForInStatement:self];
    [self.expression accept:visitor];
    [self.value accept:visitor];
    [self.scopeImp accept:visitor];
}
@end

@implementation ORControlStatNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitControlStatNode:self];
    [self.expression accept:visitor];
}
@end

@implementation ORPropertyNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitPropertyNode:self];
    [self.var accept:visitor];
}
@end

@implementation ORMethodDeclNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitMethodDeclNode:self];
    [self.returnType accept:visitor];
    [self.parameters accept:visitor];
}
@end

@implementation ORMethodNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitMethodNode:self];
    [self.declare accept:visitor];
    [self.scopeImp accept:visitor];
}
@end

@implementation ORClassNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitClassNode:self];
    [self.nodes accept:visitor];
    ;
}
@end

@implementation ORProtocolNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitProtocolNode:self];
    [self.nodes accept:visitor];
}
@end

@implementation ORStructStatNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitStructStatNode:self];
    [self.fields accept:visitor];
}
@end

@implementation ORUnionStatNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitUnionStatNode:self];
    [self.fields accept:visitor];
}
@end

@implementation OREnumStatNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitEnumStatNode:self];
    [self.fields accept:visitor];
}
@end

@implementation ORTypedefStatNode (Visitor)
- (void)accept:(id<AstVisitor>)visitor {
    [visitor visitTypedefStatNode:self];
    [self.expression accept:visitor];
}
@end
