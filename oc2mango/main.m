//
//  main.m
//  oc2mango
//
//  Created by Jiang on 2019/4/10.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <oc2mangoLib/oc2mangoLib.h>
long long fileSizeAtPath(NSString* filePath)
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
float folderSizeAtPath(NSString *folderPath){
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += fileSizeAtPath(fileAbsolutePath);
    }
    return folderSize;
}
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
    NSDate *startDate = [NSDate new];
    NSDate *endDate = [NSDate new];
    startDate = [NSDate new];
    
    recursiveLookupCompileFiles(inputDir, dirs, files);
    AST *result = [AST new];
    for (NSString *path in files) {
        AST *ast = [OCParser parseCodeSource:[[CodeSource alloc] initWithFilePath:path]];
        [result merge:ast.nodes];
    }
    endDate = [NSDate new];
    NSLog(@"raw files size: %.2fKB", folderSizeAtPath(inputDir) / 1000);
    NSLog(@"compile time: %fs",[endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]);

    startDate = [NSDate new];
    NSData *encryptData = [[NSData data] initWithContentsOfFile:@"/Users/jiang/Downloads/oc2mango/oc2mangoLib/ClassEncryptMap.json"];
    NSData *decryptData = [[NSData data] initWithContentsOfFile:@"/Users/jiang/Downloads/oc2mango/oc2mangoLib/ClassDecryptMap.json"];
    NSDictionary *encrypt = [NSJSONSerialization JSONObjectWithData:encryptData options:0 error:nil];
    NSDictionary *decrypt = [NSJSONSerialization JSONObjectWithData:decryptData options:0 error:nil];
    NSArray *jsonNodes = [JSONPatchHelper patchFileTest:result.nodes encrptMap:encrypt decrptMap:decrypt];
    endDate = [NSDate new];
    NSLog(@"json serialization, deserialization time: %fs",[endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]);
    result = [AST new];
    [result merge:jsonNodes];
    
    NSString *filePath = @"/Users/jiang/Downloads/OCRunner/oc2mango/oc2mango/Output/BinaryPatch.txt";
    NSData *data = nil;
    uint32_t cursor = 0;
    startDate = [NSDate new];
    ORPatchFile *file = [ORPatchFile new];
    _PatchNode *node = nil;
    
    file.nodes = result.nodes;
    node = _PatchNodeConvert(file);

    //Serialization
    //TODO: 压缩，_ORNode结构体中不包含length字段.
    void *buffer = malloc(node->length);
    _PatchNodeSerialization(node, buffer, &cursor);
    data = [[NSData alloc] initWithBytes:buffer length:node->length];
    _PatchNodeDestroy(node);
    
    [data writeToFile:filePath atomically:YES];

    //Deserialization
    data = [[NSData alloc] initWithContentsOfFile:filePath];
    void *fileBuffer = (void *)data.bytes;
    cursor = 0;
    node = _PatchNodeDeserialization(fileBuffer, &cursor, (uint32_t)data.length);
    file = _PatchNodeDeConvert(node);
    _PatchNodeDestroy(node);
    
    endDate = [NSDate new];
    NSLog(@"binary serialization time: %fs",[endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]);
    NSLog(@"binary length: %luKB",data.length / 1000);
    result = [AST new];
    [result merge:file.nodes];
    
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


