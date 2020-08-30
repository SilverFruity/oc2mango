//
//  PatchFile.h
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONPatchHelper.h"
#import "BinaryPatchHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface ORPatchFile : NSObject
/// target app version of patch
@property(nonatomic, copy)NSString *appVersion;
/// target os version of patch
@property(nonatomic, copy)NSString *osVersion;

@property(nonatomic, assign)BOOL enable;

@property(nonatomic, strong)NSMutableArray *strings;

@property(nonatomic, strong)NSMutableArray *nodes;

- (instancetype)initWithNodes:(NSArray *)nodes;

+ (instancetype)loadBinaryPatch:(NSString *)patchPath;
- (void)dumpAsBinaryPatch:(NSString *)patchPath;

+ (instancetype)loadJsonPatch:(NSString *)patchPatch decrptMapPath:(NSString *)decrptMapPath;
- (void)dumpAsJsonPatch:(NSString *)patchPath encrptMapPath:(NSString *)encrptMapPath;
@end
NS_ASSUME_NONNULL_END
