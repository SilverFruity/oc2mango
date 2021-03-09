//
//  GlobalTypeTable.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/3/8.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ORPatchFile/RunnerClasses.h>
NS_ASSUME_NONNULL_BEGIN
typedef enum {
    StructType,
    UnionTyep,
    ClassType,
    EnumType,
    TypedefType
}GlobalType;
@interface GlobalTypeItem: NSObject
@property(nonatomic, assign)GlobalType type;
@property(nonatomic, copy)NSString* name;
@property(nonatomic, strong)id node;
+ (instancetype)itemWithName:(NSString *)name type:(GlobalType)type node:(id)node;
@end
@interface GlobalTypeTable : NSObject
- (void)addTypeItem:(GlobalTypeItem *)item;
- (GlobalTypeItem *)typeItemForTypeName:(NSString *)typeName;
- (void)addStruct:(ORStructStatNode *)node;
- (void)addUnion:(ORUnionStatNode *)node;
- (void)addEnum:(OREnumStatNode *)node;
- (void)addClass:(ORClassNode *)node;
- (void)addTypedef:(ORTypedefStatNode *)node;
@end

NS_ASSUME_NONNULL_END
