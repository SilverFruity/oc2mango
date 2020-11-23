//
//  Archive.h
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/27.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ORNode;
NS_ASSUME_NONNULL_BEGIN
@class ORPatchFile;
@interface JSONPatchClassEncrypt: NSObject
@property(nonatomic, copy)NSString *nodeName;
@property(nonatomic, copy)NSDictionary <NSString*, NSString*>*fieldEncryptMap;
@property(nonatomic, copy)NSArray <NSString *>*fieldNames;
+ (instancetype)encryptWithDict:(NSDictionary *)dict;
@end

@interface JSONPatchClassDecrypt: NSObject
@property(nonatomic, copy)NSString *className;
@property(nonatomic, copy)NSDictionary <NSString*, NSString*>*fieldDecryptMap;
@property(nonatomic, copy)NSArray <NSString *>*fieldNames;
+ (instancetype)decryptWithDict:(NSDictionary *)dict;
@end


@interface JSONPatchHelper : NSObject
+ (NSDictionary *)archivePatch:(ORPatchFile *)patch;
+ (ORPatchFile *)unArchivePatch:(NSDictionary *)patch;
#if DEBUG
+ (NSArray <ORNode *>*)patchFileTest:(NSArray <ORNode *>*)nodes;
#endif
@end

NS_ASSUME_NONNULL_END
