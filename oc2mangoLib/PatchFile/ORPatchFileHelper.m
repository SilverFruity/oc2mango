//
//  Archive.m
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/27.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "ORPatchFileHelper.h"
@implementation ClassEncrypt
@end
@implementation ClassDecrypt
@end
NSDictionary *archiveNode(ORNode *node, NSDictionary *encryptMap){
    NSMutableDictionary *nodeData = [@{} mutableCopy];
    ClassEncrypt *item = [ClassEncrypt new];
    [item setValuesForKeysWithDictionary:encryptMap[NSStringFromClass([node class])]];
    nodeData[@"nodeName"] = item.nodeName;
    for (NSString *name in item.filedNames){
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
    [item setValuesForKeysWithDictionary:nodeData[nodeName]];
    ORNode *node = [[NSClassFromString(item.className) alloc] init];
    for (NSString *name in item.filedNames){
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

@implementation ORPatchFileHelper
+ (NSArray <NSDictionary *>*)archiveNodes:(NSArray <ORNode *>*)nodes encrptMap:(nullable NSDictionary *)cryptoMap{
    NSMutableArray *array = [@[] mutableCopy];
    for (ORNode *node in nodes){
        [array addObject:archiveNode(node, cryptoMap)];
    }
    return [array copy];
}
+ (NSArray <ORNode *>*)unArchiveNodes:(NSArray <NSDictionary *>*)nodes decrptMap:(nullable NSDictionary *)cryptoMap{
    NSMutableArray *array = [@[] mutableCopy];
    for (NSDictionary *node in nodes){
        [array addObject:unArchiveNode(node, cryptoMap)];
    }
    return [array copy];
}
@end
