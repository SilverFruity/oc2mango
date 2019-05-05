//
//  VariableDeclare.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeSpecial.h"
@interface VariableDeclare : NSObject <NSCopying>
@property TypeSpecial *type;
@property NSString *name;
@end



