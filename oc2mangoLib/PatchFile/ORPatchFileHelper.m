//
//  Archive.m
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/27.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "ORPatchFileArchiveHelper.h"
@implementation ClassEncrypt
@end
@implementation ClassDecrypt
@end
NSDictionary *archiveNode(ORNode *node, NSDictionary *encryptMap){
    NSMutableDictionary *nodeData = [@{} mutableCopy];
    ClassEncrypt *item = [ClassEncrypt new];
    NSDictionary *classInfo = encryptMap[NSStringFromClass([node class])];
    [item setValuesForKeysWithDictionary:classInfo];
    nodeData[@"nodeName"] = item.nodeName;
    for (NSString *name in item.fieldNames){
        id value = [node valueForKey:name];
        NSString *encryptName = item.fieldEncryptMap[name];
        if ([value isKindOfClass:[ORNode class]]) {
            nodeData[encryptName] = archiveNode(value, encryptMap);
        }else if([value isKindOfClass:[NSArray class]]){
            NSMutableArray *array = [NSMutableArray array];
            for (id element in value){
                if ([element isKindOfClass:[ORNode class]]) {
                    [array addObject:archiveNode(element, encryptMap)];
                }else{
                    [array addObject:element];
                }
            }
            nodeData[encryptName] = array;
        }else{
            nodeData[encryptName] = value;
        }
    }
    return nodeData;
}
ORNode *unArchiveNode(NSDictionary *nodeData, NSDictionary *decryptMap){
    NSString *nodeName = nodeData[@"nodeName"];
    ClassDecrypt *item = [ClassDecrypt new];
    [item setValuesForKeysWithDictionary:decryptMap[nodeName]];
    ORNode *node = [[NSClassFromString(item.className) alloc] init];
    for (NSString *name in item.fieldNames){
        id value = nodeData[name];
        NSString *decryptName = item.fieldDecryptMap[name];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [node setValue:unArchiveNode(value, decryptMap) forKey:decryptName];
        }else if([value isKindOfClass:[NSArray class]]){
            NSMutableArray *array = [NSMutableArray array];
            for (id element in value){
                if ([element isKindOfClass:[NSDictionary class]]) {
                    [array addObject:unArchiveNode(element, decryptMap)];
                }else{
                    [array addObject:element];
                }
            }
            [node setValue:array forKey:decryptName];
        }else{
            [node setValue:value forKey:decryptName];
        }
    }
    return node;
}

@implementation ORPatchFileArchiveHelper
#if DEBUG
+ (NSArray<ORNode *> *)patchFileTest:(NSArray<ORNode *> *)nodes{
    NSArray *array = [self archiveNodes:nodes encrptMap:nil];
    NSArray *result = [self unArchiveNodes:array decrptMap:nil];
    return result;
}
#endif

+ (NSArray <NSDictionary *>*)archiveNodes:(NSArray <ORNode *>*)nodes encrptMap:(nullable NSDictionary *)cryptoMap{
    if (cryptoMap == nil) {
        NSString *path = [[NSBundle bundleForClass:[ORPatchFileArchiveHelper class]] pathForResource:@"ClassEncryptMap.json" ofType:nil];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        cryptoMap = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    NSMutableArray *array = [@[] mutableCopy];
    for (ORNode *node in nodes){
        [array addObject:archiveNode(node, cryptoMap)];
    }
    return [array copy];
}
+ (NSArray <ORNode *>*)unArchiveNodes:(NSArray <NSDictionary *>*)nodes decrptMap:(nullable NSDictionary *)cryptoMap{
    if (cryptoMap == nil) {
        NSString *path = [[NSBundle bundleForClass:[ORPatchFileArchiveHelper class]] pathForResource:@"ClassDecryptMap.json" ofType:nil];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        cryptoMap = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    NSMutableArray *array = [@[] mutableCopy];
    for (NSDictionary *node in nodes){
        [array addObject:unArchiveNode(node, cryptoMap)];
    }
    return [array copy];
}
@end
