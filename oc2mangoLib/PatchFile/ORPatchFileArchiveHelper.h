//
//  Archive.h
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/27.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunnerClasses.h"
NS_ASSUME_NONNULL_BEGIN
@class ORPatchFile;
@interface ClassEncrypt: NSObject
@property(nonatomic, copy)NSString *nodeName;
@property(nonatomic, copy)NSDictionary <NSString*, NSString*>*fieldEncryptMap;
@property(nonatomic, copy)NSArray <NSString *>*fieldNames;
+ (instancetype)encryptWithDict:(NSDictionary *)dict;
@end

@interface ClassDecrypt: NSObject
@property(nonatomic, copy)NSString *className;
@property(nonatomic, copy)NSDictionary <NSString*, NSString*>*fieldDecryptMap;
@property(nonatomic, copy)NSArray <NSString *>*fieldNames;
+ (instancetype)decryptWithDict:(NSDictionary *)dict;
@end


@interface ORPatchFileArchiveHelper : NSObject
+ (NSDictionary *)archivePatch:(ORPatchFile *)patch encrptMap:(nullable NSDictionary *)cryptoMap;
+ (ORPatchFile *)unArchivePatch:(NSDictionary *)patch decrptMap:(nullable NSDictionary *)cryptoMap;
#if DEBUG
+ (NSArray <ORNode *>*)patchFileTest:(NSArray <ORNode *>*)nodes;
+ (NSArray <ORNode *>*)patchFileTest:(NSArray <ORNode *>*)nodes encrptMap:(nullable NSDictionary *)cryptoMap decrptMap:(nullable NSDictionary *)cryptoMap;
#endif
@end

NS_ASSUME_NONNULL_END
