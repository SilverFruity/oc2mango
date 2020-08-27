//
//  PatchFile.m
//  oc2mangoLib
//
//  Created by Jiang on 2020/8/25.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "ORPatchFile.h"

@implementation ORPatchFile
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.appVersion = @"*";
        self.osVersion = @"*";
        self.stringMap = [NSMutableDictionary dictionary];
        self.strings = [NSMutableArray array];
        self.nodes = [NSMutableArray array];
    }
    return self;
}
- (instancetype)loads:(NSString *)path{
    return nil;
}
- (void)dumps:(NSString *)path{
    
}
@end
