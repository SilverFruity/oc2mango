//
//  AST.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ORPatchFile/RunnerClasses.h>
NS_ASSUME_NONNULL_BEGIN
@class AST;
int startClassProrityDetect(AST *ast, ORClassNode *class);
extern ORClassNode *curClassNode;
extern ORProtocolNode *curProtocolNode;
void handlePrivateVarDecls(NSArray *decls);
void handlePropertyDecls(ORPropertyNode *node);
void handleMethodDecl(ORMethodDeclNode *node);
void handleMethodImp(ORMethodNode *node);
extern AST *GlobalAst;
@interface AST : NSObject
@property(nonatomic,strong)ocScope *scope;
@property(nonatomic,nonnull,strong)NSMutableArray *nodes;
@property(nonatomic,nonnull,strong)NSMutableArray *globalStatements;
@property(nonatomic,nonnull,strong)NSMutableDictionary *classCache;
@property(nonatomic,nonnull,strong)NSMutableDictionary *protcolCache;
- (nonnull ORClassNode *)classForName:(NSString *)className;
- (nonnull ORProtocolNode *)protcolForName:(NSString *)protcolName;
- (void)addGlobalStatements:(id)objects;
- (NSArray <ORClassNode *>*)sortClasses;
/// 合并ast
- (void)merge:(NSArray *)nodes;
@end
NS_ASSUME_NONNULL_END
