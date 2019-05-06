//
//  Parser.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/4/24.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <oc2mangoLib/ClassImplementation.h>
#import <oc2mangoLib/ClassDeclare.h>
#define OCParser [Parser shared]
@interface Parser : NSObject
@property(nonatomic,strong)NSMutableArray <ClassDeclare *>*classInterfaces;
@property(nonatomic,strong)NSMutableArray <ClassImplementation *>*classImps;
+ (instancetype)shared;
- (void)parseSource:(NSString *)source;
- (void)clear;
@end
