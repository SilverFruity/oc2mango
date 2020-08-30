//
//  PatchFile.m
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "ORPatchFile.h"

@implementation ORPatchFile
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.appVersion = @"*";
        self.osVersion = @"*";
        self.strings = [NSMutableArray array];
        self.nodes = [NSMutableArray array];
    }
    return self;
}
- (instancetype)initWithNodes:(NSArray *)nodes{
    self = [self init];
    self.nodes = [nodes mutableCopy];
    return self;
}
+ (instancetype)loadBinaryPatch:(NSString *)patchPath{
    NSData *data = [[NSData alloc] initWithContentsOfFile:patchPath];
    if (data == nil) {
        return nil;
    }
    void *buffer = (void *)[data bytes];
    uint32_t cursor = 0;
    _PatchNode *node = _PatchNodeDeserialization(buffer, &cursor, (uint32_t)data.length);
    ORPatchFile *file = _PatchNodeDeConvert(node);
    _PatchNodeDestroy(node);
    return file;
}
- (void)dumpAsBinaryPatch:(NSString *)patchPath{
    uint32_t length = 0;
    _PatchNode *node = _PatchNodeConvert(self, &length);
    void *buffer = malloc(length);
    uint32_t cursor = 0;
    _PatchNodeSerialization(node, buffer, &cursor);
    _PatchNodeDestroy(node);
    NSData *data = [[NSData alloc]initWithBytes:buffer length:length];
    [data writeToFile:patchPath atomically:YES];
    NSLog(@"binary file length %.2f KB", (double)length / 1000.0);
    return;
}
+ (instancetype)loadJsonPatch:(NSString *)patchPatch decrptMapPath:(NSString *)decrptMapPath{
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:patchPatch];
    if (fileData == nil) {
        return nil;
    }
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:&error];
    if (error) {
        NSLog(@"%@",error);
        return nil;
    }
    NSDictionary *decrptMap = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:decrptMapPath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:decrptMapPath];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error == nil) {
            decrptMap = dict;
        }
    }
    NSLog(@"json file length %.2f KB", (double)fileData.length / 1000.0);
    return [JSONPatchHelper unArchivePatch:jsonDict decrptMap:decrptMap];
}
- (void)dumpAsJsonPatch:(NSString *)patchPath encrptMapPath:(NSString *)encrptMapPath{
    NSDictionary *encrptMap = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:encrptMapPath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:encrptMapPath];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error == nil) {
            encrptMap = dict;
        }
    }
    NSDictionary *dictionary = [JSONPatchHelper archivePatch:self encrptMap:encrptMap];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    [data writeToFile:patchPath atomically:YES];
}
@end
