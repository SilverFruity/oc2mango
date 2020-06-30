//
//  main.m
//  oc2mango
//
//  Created by Jiang on 2019/4/10.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <oc2mangoLib/oc2mangoLib.h>
#import "NSArray+Functional.h"
void recursiveLookupCompileFiles(NSString *path,NSMutableArray *dirs,NSMutableArray *files){
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        if ([@[@"h",@"m"] containsObject:path.pathExtension.lowercaseString]) {
            [files addObject:path];
        }else if (isDir) {
            [dirs addObject:path];
            NSError *error;
            NSArray <NSString *> *filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
            for (NSString *filename in filenames) {
                recursiveLookupCompileFiles([path stringByAppendingPathComponent:filename],dirs,files);
            }
            return;
        }
    }
}
void compileFiles(NSMutableArray *files){
    NSMutableArray *headers = [files filter:^BOOL(NSUInteger index, NSString *path) {
        return [path.pathExtension.lowercaseString isEqualToString:@"h"];
    }];
    NSMutableArray *implementations = [files filter:^BOOL(NSUInteger index, NSString *path) {
        return [path.pathExtension.lowercaseString isEqualToString:@"m"];
    }];
    
    //1. 扫描所有头文件生成 Class的property、TypeDeclareSymbol
    for (NSString *path in headers) {
        [OCParser parseCodeSource:[[CodeSource alloc] initWithFilePath:path]];
    }
    
    //2. 扫描实现文件完成转换
    for (NSString *path in implementations) {
        [OCParser parseCodeSource:[[CodeSource alloc] initWithFilePath:path]];
    }
}

int main(int argc, const char * argv[]) {
    char opt = 0;
    BOOL help = NO;
    while ((opt = getopt(argc, (char * const *)argv, "h")) != -1) {
        switch (opt) {
            case 'h':{
                help = YES;
                break;
            }
            default:{
                break;
            }
        }
    }
    if (help || argc != 3) {
        printf("oc2mango input_dir output_dir \n");
        printf("Example: oc2mango /HMFilesDir /mangoFilesDir \n");
        return 0;
    }
    NSString *inputDir  = [NSString stringWithUTF8String:argv[1]];
    NSString *outputDir = [NSString stringWithUTF8String:argv[2]];
    BOOL isDir = YES;
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:outputDir isDirectory:&isDir];
    if (existed && !isDir){
        NSLog(@"输出路径已经存在，不为文件夹~");
        return 0;
    }
    if (!existed){
        [[NSFileManager defaultManager] createDirectoryAtPath:outputDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSMutableArray *dirs = [NSMutableArray array];
    NSMutableArray *files = [NSMutableArray array];
    recursiveLookupCompileFiles(inputDir, dirs, files);
    compileFiles(files);
    if (OCParser.isSuccess) {
        Convert *convert = [[Convert alloc] init];
//        for (id statement in OCParser.ast.globalStatements) {
//            NSLog(@"%@",[convert convert:statement]);
//        }
        [OCParser.ast.classCache enumerateKeysAndObjectsUsingBlock:^(NSString * key, ORClass *class, BOOL * _Nonnull stop) {
            NSString *filename = [NSString stringWithFormat:@"%@.mg",key];
            NSString *filepath = [outputDir stringByAppendingPathComponent:filename];
            NSError *error = nil;
            [[convert convert:class] writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"%@ - error: %@",filepath, error.localizedDescription);
            }
        }];
    }
    return 1;
}


