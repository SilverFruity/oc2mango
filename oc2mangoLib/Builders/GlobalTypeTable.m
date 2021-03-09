//
//  GlobalTypeTable.m
//  oc2mangoLib
//
//  Created by Jiang on 2021/3/8.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "GlobalTypeTable.h"
#import "Env.h"
@implementation GlobalTypeItem
+ (instancetype)itemWithName:(NSString *)name type:(GlobalType)type node:(id)node{
    GlobalTypeItem *item = [GlobalTypeItem new];
    item.name = name;
    item.type = type;
    item.node = node;
    return item;
}
@end

@implementation GlobalTypeTable
{
    NSMutableDictionary<NSString *, GlobalTypeItem *> *_table;
}
- (instancetype)init{
    if (self = [super init]) {
        _table = [NSMutableDictionary dictionary];
    }
    return self;
}
+ (instancetype)shareInstance{
    static id st_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        st_instance = [[GlobalTypeTable alloc] init];
    });
    return st_instance;
}
- (void)addTypeItem:(GlobalTypeItem *)item{
    _table[item.name] = item;
}
- (GlobalTypeItem *)typeItemForTypeName:(NSString *)typeName{
    return _table[typeName];
}
- (void)addStruct:(ORStructStatNode *)node{
    GlobalTypeItem *item = [GlobalTypeItem itemWithName:node.sturctName type:StructType node:node];
    [self addTypeItem:item];
}
- (void)addUnion:(ORUnionStatNode *)node{
    GlobalTypeItem *item = [GlobalTypeItem itemWithName:node.unionName type:UnionTyep node:node];
    [self addTypeItem:item];
}
- (void)addEnum:(OREnumStatNode *)node{
    GlobalTypeItem *item = [GlobalTypeItem itemWithName:node.enumName type:EnumType node:node];
    [self addTypeItem:item];
}
- (void)addClass:(ORClassNode *)node{
    GlobalTypeItem *item = [GlobalTypeItem itemWithName:node.className type:ClassType node:node];
    [self addTypeItem:item];
}
- (void)addTypedef:(ORTypedefStatNode *)node{
    GlobalTypeItem *item = [GlobalTypeItem itemWithName:node.typeNewName type:StructType node:node];
    [self addTypeItem:item];
    
    
}
@end
