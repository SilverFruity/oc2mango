//
//  TypeSpecial.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SpecialTypeUChar,
    SpecialTypeUShort,
    SpecialTypeUInt,
    SpecialTypeULong,
    SpecialTypeULongLong,

    SpecialTypeChar,
    SpecialTypeShort,
    SpecialTypeInt,
    SpecialTypeLong,
    SpecialTypeLongLong,
    
    SpecialTypeDouble,
    SpecialTypeFloat,
    
    SpecialTypeVoid,
    
    SpecialTypeSEL,
    SpecialTypeClass,
    SpecialTypeBOOL,
    SpecialTypeId,
    
    SpecialTypeUnKnown,
    SpecialTypeObject,
    SpecialTypeBlock
} SpecialType;

@class TypeSpecial;



@interface TypeSpecial : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) SpecialType type;
@property (nonatomic, assign) BOOL isPointer;

+ (instancetype)specialWithType:(SpecialType )type name:(NSString *)name;
@end
