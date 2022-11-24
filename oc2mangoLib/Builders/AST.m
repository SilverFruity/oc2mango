//
//  AST.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "AST.h"
#import "MakeDeclare.h"
#import "AstVisitor.h"

ORClassNode *curClassNode = nil;
ORProtocolNode *curProtocolNode = nil;

void handlePrivateVarDecls(NSArray *decls){
    if (curClassNode)
        [curClassNode.nodes addObjectsFromArray:decls];
}
void handlePropertyDecls(ORPropertyNode *node){
    if (curClassNode)
        [curClassNode.nodes addObject:node];
    if (curProtocolNode)
        [curProtocolNode.nodes addObject:node];
}
void handleMethodDecl(ORMethodDeclNode *node){
    if (curProtocolNode)
        [curProtocolNode.nodes addObject:node];
}
void handleMethodImp(ORMethodNode *node){
    if (curClassNode)
        [curClassNode.nodes addObject:node];
}
AST *GlobalAst = nil;
void classProrityDetect(AST *ast,ORClassNode *class, int *level){
    if ([class.superClassName isEqualToString:@"NSObject"] || NSClassFromString(class.superClassName) != nil) {
        return;
    }
    ORClassNode *superClass = ast.classCache[class.superClassName];
    if (superClass) {
        (*level)++;
    }else{
        return;
    }
    classProrityDetect(ast, superClass, level);
}
int startClassProrityDetect(AST *ast, ORClassNode *clazz){
    int prority = 0;
    classProrityDetect(ast, clazz, &prority);
    return prority;
}
@implementation AST
{
    ORClassNode * _topLevel;
}
- (ORClassNode *)classForName:(NSString *)className{
    NSAssert(className != nil && className.length > 0, @"");
    ORClassNode *class = self.classCache[className];
    if (!class) {
        class = makeOCClass(className);
        [self.classes addObject:class];
        self.classCache[className] = class;
    }
    return class;
}
- (nonnull ORProtocolNode *)protcolForName:(NSString *)protcolName{
    ORProtocolNode *protocol = self.protcolCache[protcolName];
    if (!protocol) {
        protocol = makeORProtcol(protcolName);
        [self.topLevel.nodes addObject:protocol];
        self.protcolCache[protcolName] = protocol;
    }
    return protocol;
}
- (instancetype)init
{
    self = [super init];
    _topLevel = [ORClassNode classNodeWithClassName:nil];
    _classCache = [NSMutableDictionary dictionary];
    _protcolCache = [NSMutableDictionary dictionary];
    _topLevel.isTopLevel = YES;
    _classes = [@[self.topLevel] mutableCopy];
    return self;
}
- (void)addGlobalStatements:(id)objects{
    if ([objects isKindOfClass:[NSArray class]]) {
        [self.topLevel.nodes addObjectsFromArray:objects];
    }else{
        [self.topLevel.nodes addObject:objects];
    }
}
- (NSArray *)sortClasses{
    //TODO: 根据Class继承关系，进行排序
    NSMutableDictionary <NSString *, NSNumber *>*classProrityDict = [@{} mutableCopy];
    for (ORClassNode *clazz in self.classCache.allValues) {
        classProrityDict[clazz.className] = @(startClassProrityDetect(self,clazz));
    }
    NSArray *classes = self.classCache.allValues;
    classes = [classes sortedArrayUsingComparator:^NSComparisonResult(ORClassNode *obj1, ORClassNode *obj2) {
        return classProrityDict[obj1.className].intValue > classProrityDict[obj2.className].intValue;
    }];
    return [classes copy];
}
- (void)merge:(NSArray *)classes{
    [classes enumerateObjectsUsingBlock:^(ORNode *node, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([node isKindOfClass:[ORClassNode class]]) {
            ORClassNode *classNode = (ORClassNode *)node;
            bool isTopLevel = classNode.isTopLevel;
            ORClassNode *current = isTopLevel ? self.topLevel : self.classCache[classNode.className];
            if (current) {
                [current merge:classNode key:@"nodes"];
                if (!current.superClassName && classNode.superClassName) {
                    current.superClassName = classNode.superClassName;
                }
            }else{
                self.classCache[classNode.className] = classNode;
                [self.classes addObject:classNode];
            }
        }else if([node isKindOfClass:[ORProtocolNode class]]){
            ORProtocolNode *protocolNode = (ORProtocolNode *)node;
            self.protcolCache[protocolNode.protcolName] = protocolNode;
            [self.topLevel.nodes addObject:protocolNode];
        }else{
            [self addGlobalStatements:node];
        }
    }];
}

- (void)prepareForAccept {
    NSArray *sortedClasses = [self sortClasses];
    self.classes = [@[self.topLevel] mutableCopy];
    [self.classes addObjectsFromArray:sortedClasses];
}

- (void)accept:(id<AstVisitor>)visitor {
    [self.nodes accept:visitor];
}

- (NSMutableArray *)globalStatements {
    return self.topLevel.nodes;
}

- (NSMutableArray *)nodes {
    NSMutableArray *list = [NSMutableArray array];
    [list addObjectsFromArray:self.topLevel.nodes];
    [list addObjectsFromArray:[self.classes subarrayWithRange:NSMakeRange(1, self.classes.count - 1)]];
    return list;
}
@end

