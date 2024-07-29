//
//  Parser.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Parser.h"
#import "RunnerClasses.h"
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

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static Parser * _instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [Parser new];
    });
    return _instance;
}
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

    source.error = self.error;

    if (self.error) {
        NSLog(@"\n----Error: \n  PATH: %@\n  INFO:%@",self.source.filePath,self.error);
    }
    
//#define JSON_PATCH_TEST
#ifdef JSON_PATCH_TEST
    do {
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *filePath = [cachePath stringByAppendingPathComponent:@"patch.json"];
        ORPatchFile *file = [[ORPatchFile alloc] initWithNodes:GlobalAst.nodes];
        [file dumpAsJsonPatch:filePath encrptMapPath:nil];
        ORPatchFile *newFile = [ORPatchFile loadJsonPatch:filePath decrptMapPath:nil];
        GlobalAst = [AST new];
        [GlobalAst merge:newFile.nodes];
    } while (0);
#endif
    
#ifndef PATCH_FILE_CODE_GEN
    
//#define BINARY_PATCH_TEST
#ifdef BINARY_PATCH_TEST
    do {
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *filePath = [cachePath stringByAppendingPathComponent:@"BinaryPatch.png"];
        ORPatchFile *file = [[ORPatchFile alloc] initWithNodes:GlobalAst.nodes];
        filePath = [file dumpAsBinaryPatch:filePath];
        ORPatchFile *newFile = [ORPatchFile loadBinaryPatch:filePath];
        if (newFile) {
            GlobalAst = [AST new];
            [GlobalAst merge:newFile.nodes];
        }
    } while (0);
#endif
    
#endif

// not work for 'BinaryPatchCodeGenerator' project
#if !defined(BINARY_CODE_GENERATOR)
    // add nodeType and parendNode for all nodes
    AstNodeListTagged(GlobalAst, GlobalAst.nodes);
#endif

    return GlobalAst;
}
- (AST *)parseSource:(NSString *)source{
    return [self parseCodeSource:[[CodeSource alloc] initWithSource:source]];
}

@end
