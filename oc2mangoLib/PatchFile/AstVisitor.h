//
//  AstVisitor.h
//  ORPatchFile
//
//  Created by Jiang on 2021/6/24.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AstClasses.h"
//VSCode正则: @interface (.*)?:[.\w\W]*?@end
#define NODE_LIST(V)\
V(TypeNode)\
V(VariableNode)\
V(DeclaratorNode)\
V(FunctionDeclNode)\
V(CArrayDeclNode)\
V(BlockNode)\
V(ValueNode)\
V(IntegerValue)\
V(UIntegerValue)\
V(DoubleValue)\
V(BoolValue)\
V(MethodCall)\
V(FunctionCall)\
V(FunctionNode)\
V(SubscriptNode)\
V(AssignNode)\
V(InitDeclaratorNode)\
V(UnaryNode)\
V(BinaryNode)\
V(TernaryNode)\
V(IfStatement)\
V(WhileStatement)\
V(DoWhileStatement)\
V(CaseStatement)\
V(SwitchStatement)\
V(ForStatement)\
V(ForInStatement)\
V(ControlStatNode)\
V(PropertyNode)\
V(MethodDeclNode)\
V(MethodNode)\
V(ClassNode)\
V(ProtocolNode)\
V(StructStatNode)\
V(UnionStatNode)\
V(EnumStatNode)\
V(TypedefStatNode)\

NS_ASSUME_NONNULL_BEGIN

@protocol AstVisitor <NSObject>
@required
#define VISITOR_METHOD(node_name)\
- (void)visit##node_name:(OR##node_name *)node;
NODE_LIST(VISITOR_METHOD);
#undef VISITOR_METHOD
- (void)visitEmptyNode:(ORNode *)node;
- (void)visit:(ORNode *)node;
@end

@interface NSArray (AstVisitor)
- (void)accept:(id<AstVisitor>)visitor;
@end

#ifdef __cplusplus
extern "C" {
#endif //__cplusplus

extern void AstVisitor_VisitNode(id <AstVisitor> visitor, ORNode *node);

#ifdef __cplusplus
}
#endif //__cplusplus


NS_ASSUME_NONNULL_END
