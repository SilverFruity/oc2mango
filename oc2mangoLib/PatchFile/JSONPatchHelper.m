//
//  Archive.m
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/27.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "JSONPatchHelper.h"
#import "ORPatchFile.h"
#import "ClassSecretKeyMap.h"

@implementation JSONPatchClassEncrypt
+ (instancetype)encryptWithDict:(NSDictionary *)dict{
    JSONPatchClassEncrypt *encryt = [JSONPatchClassEncrypt new];
    encryt.nodeName = dict[@"n"];
    encryt.fieldNames = dict[@"f"];
    encryt.fieldEncryptMap = dict[@"m"];
    return encryt;
}
@end
@implementation JSONPatchClassDecrypt
+ (instancetype)decryptWithDict:(NSDictionary *)dict{
    JSONPatchClassDecrypt *encryt = [JSONPatchClassDecrypt new];
    encryt.className = dict[@"c"];
    encryt.fieldNames = dict[@"f"];
    encryt.fieldDecryptMap = dict[@"m"];
    return encryt;
}
@end

NSDictionary *archiveNode(ORNode *node, NSDictionary *encryptMap, ORPatchFile *patch);

static NSMutableDictionary <NSNumber *, NSNumber *>*_jsonPatchStringMap = nil;

id archiveRecursive(id object, NSDictionary *encryptMap, ORPatchFile *patch){
    if ([object isKindOfClass:[ORNode class]]) {
        return archiveNode(object, encryptMap, patch);
    }else if([object isKindOfClass:[NSArray class]]){
        NSMutableArray *array = [NSMutableArray array];
        for (id element in object){
            [array addObject:archiveRecursive(element, encryptMap, patch)];
        }
        return array;
    }else{
        if ([object isKindOfClass:[NSString class]]) {
            NSUInteger hashValue = [object hash];
            NSInteger index = 0;
            if (_jsonPatchStringMap[@(hashValue)]) {
                index = _jsonPatchStringMap[@(hashValue)].integerValue;
            }else{
                index = (NSInteger)patch.strings.count;
                _jsonPatchStringMap[@(hashValue)] = @(index);
                [patch.strings addObject:object];
            }
            return [NSString stringWithFormat:@"s|%@",@(index)];
        }
        return object;
    }
}
NSDictionary *archiveNode(ORNode *node, NSDictionary *encryptMap, ORPatchFile *patch){
    NSMutableDictionary *nodeData = [@{} mutableCopy];
    JSONPatchClassEncrypt *item = [JSONPatchClassEncrypt encryptWithDict:encryptMap[NSStringFromClass([node class])]];
    nodeData[@"n"] = item.nodeName;
    for (NSString *name in item.fieldNames){
        id value = [node valueForKey:name];
        NSString *encryptName = item.fieldEncryptMap[name];
        nodeData[encryptName] = archiveRecursive(value, encryptMap, patch);
    }
    return nodeData;
}
ORNode *unArchiveNode(NSDictionary *nodeData, NSDictionary *decryptMap, ORPatchFile *patch);
id unArchiveRecursive(id object, NSDictionary *decryptMap, ORPatchFile *patch){
    if ([object isKindOfClass:[NSDictionary class]]) {
        return unArchiveNode(object, decryptMap, patch);
    }else if([object isKindOfClass:[NSArray class]]){
        NSMutableArray *array = [NSMutableArray array];
        for (id element in object){
            [array addObject:unArchiveRecursive(element, decryptMap, patch)];
        }
        return array;
    }else{
        if ([object isKindOfClass:[NSString class]]) {
            if ([(NSString *)object hasPrefix:@"s|"]) {
                NSString *index = [object componentsSeparatedByString:@"|"].lastObject;
                NSString *result = patch.strings[index.integerValue];
                return result;
            }
        }
        return object;
    }
}
ORNode *unArchiveNode(NSDictionary *nodeData, NSDictionary *decryptMap, ORPatchFile *patch){
    NSString *nodeName = nodeData[@"n"];
    JSONPatchClassDecrypt *item = [JSONPatchClassDecrypt decryptWithDict:decryptMap[nodeName]];
    ORNode *node = [[NSClassFromString(item.className) alloc] init];
    for (NSString *name in item.fieldNames){
        id value = nodeData[name];
        NSString *decryptName = item.fieldDecryptMap[name];
        id result = unArchiveRecursive(value, decryptMap, patch);
        if (result) {
            [node setValue:result forKey:decryptName];
        }
    }
    return node;
}

@implementation JSONPatchHelper
#if DEBUG
+ (NSArray<ORNode *> *)patchFileTest:(NSArray<ORNode *> *)nodes{
    ORPatchFile *file = [ORPatchFile new];
    file.nodes = [nodes mutableCopy];
    NSDictionary *dictionary = [self archivePatch:file];
    NSError *error = nil;
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    NSLog(@"josn file length: %.2fKB",(double)jsondata.length / 1000.0);
    NSAssert(error == nil, error.localizedDescription);
    dictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:&error];
    NSAssert(error == nil, error.localizedDescription);
    NSArray *result = [self unArchivePatch:dictionary].nodes;
    return result;
}
#endif
+ (NSDictionary *)archivePatch:(ORPatchFile *)patch {
    
    _jsonPatchStringMap = [NSMutableDictionary dictionary];
    NSDictionary *cryptoMap;
    
    NSString *mapString = jsonEncryptString;
    NSData *data = [mapString dataUsingEncoding:NSUTF8StringEncoding];
#ifdef DEBUG
    cryptoMap = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
#else
    @try {
        cryptoMap = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
#endif
    if (!cryptoMap || ![cryptoMap isKindOfClass:[NSDictionary class]]) { return nil; }

    NSMutableArray *array = [@[] mutableCopy];

    for (ORNode *node in patch.nodes){
        [array addObject:archiveNode(node, cryptoMap, patch)];
    }
    
    return @{@"appVersion":patch.appVersion,
             @"osVersion":patch.osVersion,
             @"enable":@(patch.enable),
             @"nodes":array,
             @"strings":patch.strings};
}
+ (ORPatchFile *)unArchivePatch:(NSDictionary *)patch {
    ORPatchFile *file = [ORPatchFile new];
    [file setValuesForKeysWithDictionary:patch];
    NSDictionary *cryptoMap;
    
    NSString *mapString = jsonDecryptString;
    NSData *data = [mapString dataUsingEncoding:NSUTF8StringEncoding];
    
#ifdef DEBUG
    cryptoMap = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
#else
    @try {
        cryptoMap = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
#endif
    if (!cryptoMap || ![cryptoMap isKindOfClass:[NSDictionary class]]) { return nil; }
    
    NSArray *nodes = patch[@"nodes"];
    NSMutableArray *results = [@[] mutableCopy];
    for (NSDictionary *node in nodes){
        [results addObject:unArchiveNode(node, cryptoMap, file)];
    }
    file.nodes = results;
    return file;
}

@end
