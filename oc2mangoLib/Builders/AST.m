//
//  AST.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "AST.h"
#import "MakeDeclare.h"
NSArray *SupplementarySetArray(NSArray *source, NSArray *compared){
    NSMutableSet *sourceSet = [NSMutableSet setWithArray:source];
    NSMutableSet *compredSet = [NSMutableSet setWithArray:compared];
    [compredSet unionSet:sourceSet];
    [compredSet minusSet:sourceSet];
    return  compredSet.allObjects;
}
AST *GlobalAst = nil;
void classProrityDetect(AST *ast,ORClass *class, int *level){
    if ([class.superClassName isEqualToString:@"NSObject"] || NSClassFromString(class.superClassName) != nil) {
        return;
    }
    ORClass *superClass = ast.classCache[class.superClassName];
    if (superClass) {
        (*level)++;
    }else{
        return;
    }
    classProrityDetect(ast, superClass, level);
}
int startClassProrityDetect(AST *ast, ORClass *class){
    int prority = 0;
    classProrityDetect(ast, class, &prority);
    return prority;
}
@implementation AST
- (ORClass *)classForName:(NSString *)className{
    ORClass *class = self.classCache[className];
    if (!class) {
        class = makeOCClass(className);
        [self.nodes addObject:class];
        self.classCache[className] = class;
    }
    return class;
}
- (nonnull ORProtocol *)protcolForName:(NSString *)protcolName{
    ORProtocol *protocol = self.protcolCache[protcolName];
    if (!protocol) {
        protocol = makeORProtcol(protcolName);
        [self.nodes addObject:protocol];
        self.protcolCache[protcolName] = protocol;
    }
    return protocol;
}
- (instancetype)init
{
    self = [super init];
    self.classCache = [NSMutableDictionary dictionary];
    self.protcolCache = [NSMutableDictionary dictionary];
    self.nodes = [NSMutableArray array];
    self.globalStatements = [NSMutableArray array];
    return self;
}
- (void)addGlobalStatements:(id)objects{
    if ([objects isKindOfClass:[NSArray class]]) {
        [self.globalStatements addObjectsFromArray:objects];
        [self.nodes addObjectsFromArray:objects];
    }else{
        [self.globalStatements addObject:objects];
        [self.nodes addObject:objects];
    }
}
- (NSArray *)sortClasses{
    //TODO: 根据Class继承关系，进行排序
    NSMutableDictionary <NSString *, NSNumber *>*classProrityDict = [@{} mutableCopy];
    for (ORClass *clazz in self.classCache.allValues) {
        classProrityDict[clazz.className] = @(startClassProrityDetect(self,clazz));
    }
    NSArray *classes = self.classCache.allValues;
    classes = [classes sortedArrayUsingComparator:^NSComparisonResult(ORClass *obj1, ORClass *obj2) {
        return classProrityDict[obj1.className].intValue > classProrityDict[obj2.className].intValue;
    }];
    return classes;
}
- (void)merge:(NSArray *)nodes{
    [nodes enumerateObjectsUsingBlock:^(ORNode *node, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([node isKindOfClass:[ORClass class]]) {
            ORClass *classNode = (ORClass *)node;
            ORClass *current = self.classCache[classNode.className];
            if (current) {
                [current merge:classNode key:@"privateVariables"];
                [current merge:classNode key:@"properties"];
                [current merge:classNode key:@"protocols"];
                [current merge:classNode key:@"methods"];
                if (!current.superClassName && classNode.superClassName) {
                    current.superClassName = classNode.superClassName;
                }
            }else{
                self.classCache[classNode.className] = node;
                [self.nodes addObject:node];
            }
        }else if([node isKindOfClass:[ORProtocol class]]){
            ORProtocol *protocolNode = (ORProtocol *)node;
            self.protcolCache[protocolNode.protcolName] = protocolNode;
            [self.nodes addObject:protocolNode];
        }else{
            [self addGlobalStatements:node];
        }
    }];
}
@end

