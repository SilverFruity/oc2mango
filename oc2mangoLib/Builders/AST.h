//
//  AST.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AstClasses.h"

NS_ASSUME_NONNULL_BEGIN
@protocol AstVisitorAccepter;
@class AST;

int startClassProrityDetect(AST *ast, ORClassNode *clazz);
extern ORClassNode *curClassNode;
extern ORProtocolNode *curProtocolNode;
void handlePrivateVarDecls(NSArray *decls);
void handlePropertyDecls(ORPropertyNode *node);
void handleMethodDecl(ORMethodDeclNode *node);
void handleMethodImp(ORMethodNode *node);


extern AST *GlobalAst;
@interface AST : NSObject <AstVisitorAccepter>
@property(nonatomic,readonly)ORClassNode *topLevel;
@property(nonatomic,nonnull,strong)NSMutableArray <ORClassNode *>*classes;
@property(nonatomic,nonnull,strong)NSMutableDictionary *classCache;
@property(nonatomic,nonnull,strong)NSMutableDictionary *protcolCache;
- (nonnull ORClassNode *)classForName:(NSString *)className;
- (nonnull ORProtocolNode *)protcolForName:(NSString *)protcolName;
- (void)addGlobalStatements:(id)objects;
- (NSArray <ORClassNode *>*)sortClasses;
/// 合并ast
- (void)merge:(NSArray *)classes;
- (void)prepareForAccept;
- (void)accept:(id<AstVisitor>)visitor;
@end

@interface AST (ForUnitTest)
@property(nonatomic,readonly)NSMutableArray *globalStatements;
@property(nonatomic,readonly)NSMutableArray *nodes;
@end
NS_ASSUME_NONNULL_END
