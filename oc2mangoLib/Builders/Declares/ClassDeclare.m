//
//  ClassDeclare.m
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "ClassDeclare.h"
/*
 4.Link Check
 3.Handle GlobalVariable
 2.Prefix Compile Tool
 1.Class Pool{
    className:{
        interface/category:
        {
            protocols:
            privateVariables:
            properties:
            methods:
        }
        implementation/category:
        {
            privateVariables:
            methodsImp:
        }
 
    }
 }
 
 
 
 */
@implementation ClassDeclare
- (NSString *)description
{
    return [NSString stringWithFormat:@"\nClass %@:%@ <%@>{\n"
            "{\n"
            "%@\n"
            "}\n"
            "%@\n"
            "%@\n"
            "}", self.className,self.superClassName,
            [self.protocolNames componentsJoinedByString:@"\n"],
            [self.privateVariables componentsJoinedByString:@";\n"],
            [self.properties componentsJoinedByString:@";\n"],
            [self.methods componentsJoinedByString:@";\n"]];
}
- (BOOL)isCategory{
    return self.categoryName != nil && self.superClassName == nil;
}
@end



