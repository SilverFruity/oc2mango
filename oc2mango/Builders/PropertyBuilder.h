//
//  PropertyBuilder.h
//  oc2mango
//
//  Created by Jiang on 2019/4/20.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "CodeBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface PropertyBuilder : NSObject <CodeBuilder>
@property NSString *typeName;
@property NSString *varName;
@property NSArray *kewords;
@end

NS_ASSUME_NONNULL_END
