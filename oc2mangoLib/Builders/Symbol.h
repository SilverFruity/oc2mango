//
//  Symbol.h
//  oc2mangoLib
//
//  Created by Jiang on 2021/3/4.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>





//NOTE: ignore bit 'b'
#define TypeEncodeIsBaseType(code) (('a'<= *code && *code <= 'z') || ('A'<= *code && *code <= 'Z'))

static const char *OCTypeStringBlock = "@?";

NS_ASSUME_NONNULL_BEGIN

@interface Symbol : NSObject

@end

NS_ASSUME_NONNULL_END
