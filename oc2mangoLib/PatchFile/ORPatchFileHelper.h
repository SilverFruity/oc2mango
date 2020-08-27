//
//  Archive.h
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/27.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunnerClasses.h"
#import "ORPatchFile.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClassEncrypt: NSObject
@property(nonatomic, copy)NSString *nodeName;
@property(nonatomic, copy)NSDictionary <NSString*, NSString*>*fieldEncryptMap;
@property(nonatomic, copy)NSArray <NSString *>*filedNames;
@end

@interface ClassDecrypt: NSObject
@property(nonatomic, copy)NSString *className;
@property(nonatomic, copy)NSDictionary <NSString*, NSString*>*fieldDecryptMap;
@property(nonatomic, copy)NSArray <NSString *>*filedNames;
@end


@interface ORPatchFileHelper : NSObject
+ (NSArray <NSDictionary *>*)archiveNodes:(NSArray <ORNode *>*)nodes encrptMap:(nullable NSDictionary *)cryptoMap;
+ (NSArray <ORNode *>*)unArchiveNodes:(NSArray <NSDictionary *>*)nodes decrptMap:(nullable NSDictionary *)cryptoMap;
@end

NS_ASSUME_NONNULL_END
