//
//  ClassDeclare.h
//  oc2mango
//
//  Created by Jiang on 2019/4/21.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "PropertyDeclare.h"
#import "MethodDeclare.h"

@interface ClassDeclare : NSObject
@property NSString *className;
@property NSString *superClassName;
@property NSMutableArray *protocolNames;
@property NSMutableArray <VariableDeclare *> *privateVariables;
@property NSMutableArray <PropertyDeclare *> *properties;
@property NSMutableArray <MethodDeclare *> *methods;
@end


