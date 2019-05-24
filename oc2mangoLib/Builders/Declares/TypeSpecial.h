//
//  TypeSpecial.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 int            : SpecialTypeInt, isPoint=NO, name = nil
 int *          : SpecialTypeInt, isPoint=YES, name = nil
 NSObject *     : SpecialTypeInt, isPoint=YES, name = @"NSObject"
 SEL            : SpecialTypeSelector, isPoint=NO, name = nil
 void(^name)(x,...) : SpecialTypeBlock, isPoint=NO, name = @"name"
 */
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
@property (nonatomic, assign) SpecialType type;
@property (nonatomic, assign) NSUInteger ptCount;
@property (nonatomic, nullable, copy) NSString * name;

+ (instancetype)specialWithType:(SpecialType )type name:(NSString *)name;
@end
