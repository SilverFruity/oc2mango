//
//  AST.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "AST.h"
#import "MakeDeclare.h"
void classProrityDetect(ORClass *class, int *level){
    if ([class.superClassName isEqualToString:@"NSObject"] || NSClassFromString(class.superClassName) != nil) {
        return;
    }
    ORClass *superClass = OCParser.ast.classCache[class.superClassName];
    if (superClass) {
        (*level)++;
    }else{
        return;
    }
    classProrityDetect(superClass, level);
}
int startClassProrityDetect(ORClass *class){
    int prority = 0;
    classProrityDetect(class, &prority);
    return prority;
}
@implementation AST
- (ORClass *)classForName:(NSString *)className{
    ORClass *class = self.classCache[className];
    if (!class) {
        class = makeOCClass(className);
        self.classCache[className] = class;
    }
    return class;
}
- (instancetype)init
{
    self = [super init];
    self.classCache = [NSMutableDictionary dictionary];
    self.globalStatements = [NSMutableArray array];
    return self;
}
- (void)addGlobalStatements:(id)objects{
    if ([objects isKindOfClass:[NSArray class]]) {
        [self.globalStatements addObjectsFromArray:objects];
    }else{
        [self.globalStatements addObject:objects];
    }
}
- (NSArray *)sortClasses{
    //TODO: 根据Class继承关系，进行排序
    NSMutableDictionary <NSString *, NSNumber *>*classProrityDict = [@{} mutableCopy];
    for (ORClass *clazz in self.classCache.allValues) {
        classProrityDict[clazz.className] = @(startClassProrityDetect(clazz));
    }
    NSArray *classes = self.classCache.allValues;
    classes = [classes sortedArrayUsingComparator:^NSComparisonResult(ORClass *obj1, ORClass *obj2) {
        return classProrityDict[obj1.className].intValue > classProrityDict[obj2.className].intValue;
    }];
    return classes;
}
@end

