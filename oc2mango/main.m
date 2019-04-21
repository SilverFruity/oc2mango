//
//  main.m
//  oc2mango
//
//  Created by Jiang on 2019/4/10.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//



// 扫描所有文件 typedef #define 保存到两个文件
// 扫描所有 typedef original new -> typedefCache: { new : original}
// 扫描#define expression(A,B) orignal -> defineCache: { queue: A,B ,}
// .*(^$name)(.*?) -> Block $name
// .*(^)(.*?) -> Block
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    NSString *path  = [NSString stringWithUTF8String:argv[1]];
    NSString *source = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    extern void yy_set_source_string(char const *source);
    yy_set_source_string([source UTF8String]);
    
    extern void yyrestart (FILE * input_file );
    extern int yyparse(void);
    if (yyparse()) {
        yyrestart(NULL);
        NSLog(@"ERROR!!!");
        return 0;
    }
    
    return 0;
}


