//
//  main.m
//  oc2mango
//
//  Created by Jiang on 2019/4/10.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <oc2mangoLib/oc2mangoLib.h>
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
    AST *result = [AST new];
    for (NSString *path in files) {
        AST *ast = [OCParser parseCodeSource:[[CodeSource alloc] initWithFilePath:path]];
        [result merge:ast.nodes];
    }
    
//    NSDate *startDate = [NSDate new];
//    NSData *encryptData = [[NSData data] initWithContentsOfFile:@"/Users/jiang/Downloads/oc2mango/oc2mangoLib/ClassEncryptMap.json"];
//    NSData *decryptData = [[NSData data] initWithContentsOfFile:@"/Users/jiang/Downloads/oc2mango/oc2mangoLib/ClassDecryptMap.json"];
//    NSDictionary *encrypt = [NSJSONSerialization JSONObjectWithData:encryptData options:0 error:nil];
//    NSDictionary *decrypt = [NSJSONSerialization JSONObjectWithData:decryptData options:0 error:nil];
//    [ORPatchFileArchiveHelper patchFileTest:result.nodes encrptMap:encrypt decrptMap:decrypt];
//    NSDate *endDate = [NSDate new];
//    NSLog(@"%f",[endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]);
    
    Convert *convert = [[Convert alloc] init];
    __block NSError *error = nil;
    [result.classCache enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, ORClass* class, BOOL * _Nonnull stop) {
        NSString *filename = [NSString stringWithFormat:@"%@.mg",key];
        NSString *filepath = [outputDir stringByAppendingPathComponent:filename];
        [[convert convert:class] writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"oc2mango: %@ - error: %@",filepath, error.localizedDescription);
        }
    }];
    if (error == nil) {
        NSLog(@"oc2mango: convert success!");
    }
    return 1;
}


