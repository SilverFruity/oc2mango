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
    NSMutableArray *failedFiles = [NSMutableArray array];
    for (NSString *path in headers) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSLog(@"%@",path);
        [OCParser parseSource:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
        if (!OCParser.isSuccess) {
            [failedFiles addObject:path];
        }
    }
    
    //2. 扫描实现文件完成转换
    for (NSString *path in implementations) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSLog(@"%@",path);
        [OCParser parseSource:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
        if (!OCParser.isSuccess) {
            [failedFiles addObject:path];
        }
    }
    NSLog(@"%@",failedFiles);
    NSLog(@"%lu",failedFiles.count);
    if (OCParser.isSuccess) {
        return;
    }
}

int main(int argc, const char * argv[]) {
    NSString *path  = [NSString stringWithUTF8String:argv[1]];
    NSMutableArray *dirs = [NSMutableArray array];
    NSMutableArray *files = [NSMutableArray array];
    recursiveLookupCompileFiles(path, dirs, files);
    compileFiles(files);
    NSLog(@"%@",OCParser.stack.topTable);
    if (!OCParser.isSuccess) {
        return 0;
    }
    return 1;
}


