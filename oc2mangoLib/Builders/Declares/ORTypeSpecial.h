//
//  TypeSpecial.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    TypeChar,
    TypeUChar,
    TypeShort,
    TypeUShort,
    TypeInt,
    TypeUInt,
    TypeLong,
    TypeULong,
    TypeLongLong,
    TypeULongLong,
    TypeBOOL,
    TypeEnum,
    TypeFloat,
    TypeDouble,
    TypeLongDouble,
    TypeVoid,
    TypeUnion,
    TypeStruct,
    TypeFunction,
    TypeArray,
    TypeNSArray,
    TypeNSDictionary,
    TypeSEL,
    TypeProtocol,
    TypeClass,
    TypeObject,
    TypeBlock,
    TypeId,
    TypeUnKnown
}TypeKind;
enum{
    AttributeConst = 1,
    AttributeStatic = 1 << 1,
    AttributeVolatile = 1 << 2,
    AttributeStrong = 1 << 3,
    AttributeBlock = 1 << 4,
    AttributeWeak = 1 << 5,
    AttributeExtern = 1 << 6,
    AttributeNonnull = 1 << 7,
    AttributeNullable = 1 << 8,
    AttributeBridge = 1 << 9
};


@interface ORTypeSpecial : NSObject
@property (nonatomic, assign) TypeKind type;
@property (nonatomic, nullable, copy) NSString * name;
+ (instancetype)specialWithType:(TypeKind)type name:(NSString *)name;
@end


@interface ORVariable: NSObject
@property (nonatomic, assign) NSInteger ptCount;
@property (nonatomic, nullable, copy) NSString * varname;
+ (instancetype)copyFromVar:(ORVariable *)var;
@end

@interface ORTypeVarPair : NSObject
@property (nonatomic, strong)ORTypeSpecial *type;
@property (nonatomic, strong)ORVariable *var;
@end

@interface ORFuncVariable: ORVariable
@property(nonatomic,strong) NSMutableArray <ORTypeVarPair *>*pairs;

@end
