//
//  PatchFile.h
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORPatchFileArchiveHelper.h"
NS_ASSUME_NONNULL_BEGIN

@interface ORPatchFile : NSObject
/// target app version of patch
@property(nonatomic, copy)NSString *appVersion;
/// target os version of patch
@property(nonatomic, copy)NSString *osVersion;

@property(nonatomic, assign)BOOL enable;
/*
 * Include: linked function, struct declare，enum declare, global function declare, static variable etc...
 * So it will be the first to be executed..
 * Example: UIKitReference, CCDReference
 * It's similar to the dynamic links table of Mach-O file.
 */
@property(nonatomic, copy)NSArray <ORPatchFile *>*links;
//hash数组, 用于index定位查找
@property(nonatomic, strong)NSMutableArray *strings;
//hash: index
@property(nonatomic, strong)NSMutableDictionary <NSNumber *, NSNumber *>*stringMap;
/// the list of statements
@property(nonatomic, strong)NSMutableArray *nodes;
/// load from the patch file
- (instancetype)loads:(NSString *)path;
/// save the patch to the path
- (void)dumps:(NSString *)path;
@end
NS_ASSUME_NONNULL_END
