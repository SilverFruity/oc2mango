//
//  Log.m
//  oc2mango
//
//  Created by Jiang on 2019/4/20.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Log.h"
NSString *_generatorFormmt(size_t argc){
    NSMutableString *format = [NSMutableString string];
    for (int i = 0; i < argc; i++) {
        [format appendString:@"%@ "];
    }
    
    return format;
}

