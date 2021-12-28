//
//  Parser.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Parser.h"
#import "RunnerClasses.h"
#import "oc2mangoLib.h"

Parser *OCParser = nil;
@implementation CodeSource
- (instancetype)initWithFilePath:(NSString *)filePath{
    self = [super init];
    self.filePath = filePath;
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.source = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return self;
}
- (instancetype)initWithSource:(NSString *)source{
    self = [super init];
    self.source = source;
    return self;
}
@end
@implementation Parser
- (BOOL)isSuccess{
    return self.source && self.error == nil;
}
- (AST *)parseCodeSource:(CodeSource *)source{
    if (source.source == nil) {
        return nil;
    }
    self.error = nil;
    GlobalAst = [AST new];
    OCParser = self;
    extern void yy_set_source_string(char const *source);
    extern void yyrestart (FILE * input_file );
    extern int yyparse(void);
    self.source = source;
    yy_set_source_string([source.source UTF8String]);
    if (yyparse()) {
        yyrestart(NULL);
    }
    if (self.error) {
        NSLog(@"\n----Error: \n  PATH: %@\n  INFO:%@",self.source.filePath,self.error);
    }
    return GlobalAst;
}
- (AST *)parseSource:(NSString *)source{
    return [self parseCodeSource:[[CodeSource alloc] initWithSource:source]];
}

@end
