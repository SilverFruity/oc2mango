//
//  Parser.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Parser.h"
#import "Expression.h"
#import "Statement.h"
@implementation Parser
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static Parser * _instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [Parser new];
    });
    return _instance;
}
- (instancetype)init
{
    self = [super init];
    self.classInterfaces = [NSMutableArray array];
    self.classImps = [NSMutableArray array];
    return self;
}
- (NSArray *)expressions{
    NSMutableArray *array = [NSMutableArray array];
    for (ClassImplementation *imp in self.classImps) {
        for (MethodImplementation *methodImp in imp.methodImps ) {
            for (id <Expression>expression in methodImp.imp.statements) {
                if ([expression conformsToProtocol:@protocol(Expression)]) {
                    [array addObject:expression];
                }
            }
        }
    }
    return [array copy];
}
- (NSArray *)statements{
    NSMutableArray *array = [NSMutableArray array];
    for (ClassImplementation *imp in self.classImps) {
        for (MethodImplementation *methodImp in imp.methodImps ) {
            for (Statement *statement in methodImp.imp.statements) {
                if ([statement isKindOfClass:[Statement class]]) {
                    [array addObject:statement];
                }
            }
        }
    }
    return [array copy];
}
- (void)parseSource:(NSString *)source{
    extern void yy_set_source_string(char const *source);
    extern void yyrestart (FILE * input_file );
    extern int yyparse(void);
    self.source = source;
    yy_set_source_string([source UTF8String]);
    if (yyparse()) {
        yyrestart(NULL);
        NSLog(@"ERROR!!!");
    }
}
- (void)clear{
    [self.classInterfaces removeAllObjects];
    [self.classImps removeAllObjects];
    self.error = nil;
}
@end
