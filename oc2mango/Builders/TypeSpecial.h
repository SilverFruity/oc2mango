//
//  TypeSpecial.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SpecialTypeInt,
    SpecialTypeUInt,
    SpecialTypeClass,
    SpecialTypeBOOL,
    SpecialTypeId,
    SpecialTypeVoid,
    SpecialTypeUnKnown,
    SpecialTypeObject,
    SpecialTypeBlock
} SpecialType;
@interface TypeSpecial : NSObject

@end
