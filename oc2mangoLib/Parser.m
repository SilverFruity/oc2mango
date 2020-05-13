//
//  Parser.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Parser.h"
#import "RunnerClasses.h"
void UncaughtExceptionHandler(NSException *exception) {
    extern unsigned long yylineno;
    NSArray *array = [OCParser.source componentsSeparatedByString:@"\n"];
    NSLog(@"error :%@",array[yylineno]);
}
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
    self.ast = [AST new];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    return self;
}
- (BOOL)isSuccess{
    return self.source && self.error == nil;
}
- (void)parseSource:(NSString *)source{
    self.error = nil;
    extern void yy_set_source_string(char const *source);
    extern void yyrestart (FILE * input_file );
    extern int yyparse(void);
    self.source = source;
    yy_set_source_string([source UTF8String]);
    if (yyparse()) {
        yyrestart(NULL);
        self.error = @"ERROR !!!";
    }
}
- (void)clear{
    [self.lock lock];
    self.ast = [AST new];
    self.error = nil;
    [self.lock unlock];
}
@end
