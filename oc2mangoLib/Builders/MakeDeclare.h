//
//  MakeDeclare.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassDeclare.h"
#import "ClassImplementation.h"



ClassDeclare * makeClassDeclare(NSString *className);

extern TypeSpecial *makeTypeSpecial(SpecialType type, NSString *name);
extern TypeSpecial *makeTypeSpecial(SpecialType type) __attribute__((overloadable)) ;

extern VariableDeclare *makeVariableDeclare(TypeSpecial *type, NSString *name);

extern MethodDeclare *makeMethodDeclare(BOOL isClassMethod, TypeSpecial *returnType);
extern ClassImplementation *makeClassImplementation(NSString *className);
extern MethodImplementation *makeMethodImplementation(MethodDeclare *declare);
