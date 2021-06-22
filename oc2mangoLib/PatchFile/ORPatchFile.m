//
//  PatchFile.m
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "ORPatchFile.h"
#import <CommonCrypto/CommonDigest.h>
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
    NSData *data = [[NSData alloc] initWithContentsOfFile:patchPath];
    if (data == nil) {
        return nil;
    }
    NSLog(@"binary file length %.2f KB", (double)data.length / 1000.0);
    uint32_t fileLength = (uint32_t)data.length;
    if (fileLength <= CC_SHA256_DIGEST_LENGTH) {
        return nil;
    }
    uint8_t *fileBuffer = (uint8_t *)[data bytes];
    uint8_t *dataBuffer = fileBuffer + CC_SHA256_DIGEST_LENGTH;
    uint32_t dataLength = fileLength - CC_SHA256_DIGEST_LENGTH;
    
    // 校验文件中存储的SHA256和数据区的SHA256
    uint8_t sha256Buffer[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(dataBuffer, dataLength, sha256Buffer);
    if (memcmp(fileBuffer, sha256Buffer, CC_SHA256_DIGEST_LENGTH) != 0) {
        return nil;
    }
    uint32_t cursor = 0;
    if (AstPatchFileGenerateCheckFile(dataBuffer, dataLength).canUseable == NO) {
        return nil;
    }
    AstPatchFile *node = AstPatchFileDeserialization(dataBuffer, &cursor, dataLength);
    ORPatchFile *file = AstPatchFileDeConvert(node);
    AstPatchFileDestroy(node);
    return file;
}
- (NSString *)dumpAsBinaryPatch:(NSString *)patchPath{
    uint32_t dataLength = 0;
    AstPatchFile *node = AstPatchFileConvert(self, &dataLength);
    
    uint32_t fileLength = dataLength + CC_SHA256_DIGEST_LENGTH;
    uint8_t *fileBuffer = malloc(fileLength);
    //前32字节为SHA256值
    uint8_t *dataBuffer = fileBuffer + CC_SHA256_DIGEST_LENGTH;
    
    uint32_t cursor = 0;
    AstPatchFileSerialization(node, dataBuffer, &cursor);
    AstPatchFileDestroy(node);
    
    //用文件的前32字节来存储数据区的SHA256值
    uint8_t sha256Buffer[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(dataBuffer, dataLength, sha256Buffer);
    memcpy(fileBuffer, sha256Buffer, CC_SHA256_DIGEST_LENGTH);
    
    NSData *data = [[NSData alloc]initWithBytes:fileBuffer length:fileLength];
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
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
