//
//  PatchFile.m
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "ORPatchFile.h"
#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#endif
BOOL ORPatchFileVersionCompare(NSString *current, NSString *constaint){
    BOOL result = YES;
    NSString *deviceVersion = current;
    NSString *constraintVersion = constaint;
    if ([constraintVersion isEqualToString:@"*"]) {
        return YES;
    }
    NSString *clearedOsVersion = [constraintVersion stringByReplacingOccurrencesOfString:@">" withString:@""];
    clearedOsVersion = [clearedOsVersion stringByReplacingOccurrencesOfString:@"<" withString:@""];
    clearedOsVersion = [clearedOsVersion stringByReplacingOccurrencesOfString:@"=" withString:@""];
    clearedOsVersion = [clearedOsVersion stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSComparisonResult cmpResult = [deviceVersion compare:clearedOsVersion options:NSNumericSearch];
    if ([constraintVersion hasPrefix:@">="]) {
        result &= (cmpResult == NSOrderedDescending || cmpResult ==  NSOrderedSame);
    }else if ([constraintVersion hasPrefix:@">"]){
        result &= cmpResult == NSOrderedDescending;
    }else if ([constraintVersion hasPrefix:@"<="]) {
        result &= (cmpResult == NSOrderedAscending || cmpResult ==  NSOrderedSame);
    }else if ([constraintVersion hasPrefix:@"<"]){
        result &= cmpResult == NSOrderedAscending;
    }else{
        result &= cmpResult == NSOrderedSame;
    }
    return result;
}
@implementation ORPatchFile
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.appVersion = @"*";
        self.osVersion = @"*";
        self.strings = [NSMutableArray array];
        self.nodes = [NSMutableArray array];
        self.enable = YES;
    }
    return self;
}
- (BOOL)canUseable{
    if (self.enable == NO) {
        return NO;
    }
    BOOL useable = YES;
    useable &= ORPatchFileVersionCompare([[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"], self.appVersion);
    #if !TARGET_OS_OSX
    useable &= ORPatchFileVersionCompare([[UIDevice currentDevice] systemVersion], self.osVersion);
    #else
    NSOperatingSystemVersion version = [[NSProcessInfo processInfo] operatingSystemVersion];
    NSString *osVersion = [NSString stringWithFormat:@"%lu.%lu.%lu", version.majorVersion, version.minorVersion, version.patchVersion];
    useable &= ORPatchFileVersionCompare(osVersion, self.osVersion);
    #endif
    return useable;
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
    if (_PatchNodeGenerateCheckFile(buffer, (uint32_t)data.length).canUseable == NO) {
        return nil;
    }
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
