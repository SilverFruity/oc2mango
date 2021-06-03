//
//  PatchFile.h
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunnerClasses.h"
#import "JSONPatchHelper.h"
#import "BinaryPatchHelper.h"

NS_ASSUME_NONNULL_BEGIN
#define OCPatchFileInternalVersion @"1000.0.1"
BOOL ORPatchFileVersionCompare(NSString *current, NSString *constaint);
@interface ORPatchFile : NSObject
/*
    'enable' 属性的优先级在版本控制之上.
    关于版本控制:
    1. '>= 0.1': 当前版本号 > 0.1
    2. '> 0.1':  当前版本号 >= 0.1
    3. '<= 0.1': 当前版本号 <= 0.1
    4. '<  0.1': 当前版本号 < 0.1
    5. '=0.1' or '0.1': 当前版本号 = 0.1
    5. '*': any verson, default
 */

/// target app version of patch
@property(nonatomic, copy)NSString *appVersion;

/*
 ORPatchFile <= 1.0.4时，此参数为osVersion
 
 1.0.5 后修改为 补丁内部版本号：起始版本号为1000.0.1
 版本号为何如此高？
 利用以前版本的osVersion参数默认和系统版本比对的逻辑：目标系统版本比当前系统版本高，直接放弃序列化补丁，防止新版本的补丁在低版本下会崩溃的问题。

 */
@property(nonatomic, copy)NSString *patchInternalVersion;

@property(nonatomic, assign)BOOL enable;

@property(nonatomic, strong)NSMutableArray *strings;

@property(nonatomic, strong)NSMutableArray *nodes;

- (BOOL)canUseable;

- (instancetype)initWithNodes:(NSArray *)nodes;

+ (nullable instancetype)loadBinaryPatch:(NSString *)patchPath;
- (NSString *)dumpAsBinaryPatch:(NSString *)patchPath;

+ (nullable instancetype)loadJsonPatch:(NSString *)patchPatch;
- (NSString *)dumpAsJsonPatch:(NSString *)patchPath;
@end
NS_ASSUME_NONNULL_END
