//
//  Parser.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Parser.h"

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
- (void)parseSource:(NSString *)source{
    extern void yy_set_source_string(char const *source);
    extern void yyrestart (FILE * input_file );
    extern int yyparse(void);
    yy_set_source_string([source UTF8String]);
    if (yyparse()) {
        yyrestart(NULL);
        NSLog(@"ERROR!!!");
    }
}
- (void)clear{
    [self.classInterfaces removeAllObjects];
    [self.classImps removeAllObjects];
}
@end
