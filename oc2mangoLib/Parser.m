//
//  Parser.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "Parser.h"

@implementation Parser
- (void)parseSource:(NSString *)source{
    extern void yy_set_source_string(char const *source);
    extern void yyrestart (FILE * input_file );
    extern int yyparse(void);
    yy_set_source_string([source UTF8String]);
    if (yyparse()) {
        yyrestart(NULL);
        NSLog(@"ERROR!!!");
    }
}
@end
