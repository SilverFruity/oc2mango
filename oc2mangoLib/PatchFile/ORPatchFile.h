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
/// target os version of patch
@property(nonatomic, copy)NSString *osVersion;

@property(nonatomic, assign)BOOL enable;

@property(nonatomic, strong)NSMutableArray *strings;

@property(nonatomic, strong)NSMutableArray *nodes;

- (BOOL)canUseable;

- (instancetype)initWithNodes:(NSArray *)nodes;

+ (nullable instancetype)loadBinaryPatch:(NSString *)patchPath;
- (void)dumpAsBinaryPatch:(NSString *)patchPath;

+ (nullable instancetype)loadJsonPatch:(NSString *)patchPatch;
- (void)dumpAsJsonPatch:(NSString *)patchPath;
@end
NS_ASSUME_NONNULL_END
