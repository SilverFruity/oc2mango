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
        self.patchInternalVersion = OCPatchFileInternalVersion;
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
    
    // 针对 1.1.0 之前的版本特殊支持，1.0.4及以前默认为 *
    if ([self.patchInternalVersion isEqualToString:@"*"]) {
        useable &= YES;
    }else{
        //补丁文件的内部版本号是否 <= 当前ORPatchFile的内部版本号
        useable &= ORPatchFileVersionCompare(self.patchInternalVersion, [NSString stringWithFormat:@"<=%@",OCPatchFileInternalVersion]);
    }
    return useable;
}
- (instancetype)initWithNodes:(NSArray *)nodes{
    self = [self init];
    self.nodes = [nodes mutableCopy];
    return self;
}
+ (instancetype)loadBinaryPatch:(NSString *)patchPath{
    if ([[patchPath pathExtension] isEqualToString:@"ocrr"] == NO) {
        NSLog(@"OCRunner: 补丁仅支持.ocrr文件类型，file path:%@", patchPath);
        return nil;
    }
    NSData *data = [[NSData alloc] initWithContentsOfFile:patchPath];
    if (data == nil) {
        return nil;
    }
    NSLog(@"binary file length %.2f KB", (double)data.length / 1000.0);
    void *buffer = (void *)[data bytes];
    uint32_t cursor = 0;
    if (AstPatchFileGenerateCheckFile(buffer, (uint32_t)data.length).canUseable == NO) {
        return nil;
    }
    AstPatchFile *node = AstPatchFileDeserialization(buffer, &cursor, (uint32_t)data.length);
    ORPatchFile *file = AstPatchFileDeConvert(node);
    AstPatchFileDestroy(node);
    return file;
}
- (NSString *)dumpAsBinaryPatch:(NSString *)patchPath{
    uint32_t length = 0;
    AstPatchFile *node = AstPatchFileConvert(self, &length);
    void *buffer = malloc(length);
    uint32_t cursor = 0;
    AstPatchFileSerialization(node, buffer, &cursor);
    AstPatchFileDestroy(node);
    NSData *data = [[NSData alloc]initWithBytes:buffer length:length];
    NSString *fileExtension = [patchPath pathExtension];
    if (fileExtension.length == 0) {
        patchPath = [patchPath stringByAppendingString:@".ocrr"];
    }else if ([fileExtension isEqualToString:@"ocrr"] == NO) {
        patchPath = [patchPath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",fileExtension] withString:@".ocrr"];
    }
    [data writeToFile:patchPath atomically:YES];
    return patchPath;
}
+ (instancetype)loadJsonPatch:(NSString *)patchPatch {
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:patchPatch];
    if (fileData == nil) {
        return nil;
    }
    NSError *error;
    NSDictionary *jsonDict;
    
#ifdef DEBUG
    jsonDict = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:&error];
#else
    @try {
        jsonDict = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:&error];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
#endif
    
    if (error || !jsonDict || ![jsonDict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@",error);
        return nil;
    }
    NSLog(@"json file length %.2f KB", (double)fileData.length / 1000.0);
    ORPatchFile *file = [ORPatchFile new];
    [file setValuesForKeysWithDictionary:jsonDict];
    if (file.canUseable == NO) {
        return nil;
    }
    [JSONPatchHelper unArchivePatch:file object:jsonDict];
    return file;
}
- (NSString *)dumpAsJsonPatch:(NSString *)patchPath{
    NSDictionary *dictionary = [JSONPatchHelper archivePatch:self];
    if (!dictionary) { return @"json empty error"; }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error) {
        NSLog(@"%@",error);
        return error.localizedDescription;
    }
    [data writeToFile:patchPath atomically:YES];
    return patchPath;
}
@end
