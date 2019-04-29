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
@interface Parser : NSObject
@property(nonatomic,strong)NSMutableArray <ClassDeclare *>*classeInterfaces;
@property(nonatomic,strong)NSMutableArray <ClassImplementation *>*classeImps;
- (void)parseSource:(NSString *)source;
@end
