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
@property (nonatomic,copy) NSString *className;
@property (nonatomic,copy) NSString *superClassName;
@property (nonatomic,copy) NSString *categoryName;
@property (nonatomic,strong) NSMutableArray *protocolNames;
@property (nonatomic,strong) NSMutableArray <VariableDeclare *> *privateVariables;
@property (nonatomic,strong) NSMutableArray <PropertyDeclare *> *properties;
@property (nonatomic,strong) NSMutableArray <MethodDeclare *> *methods;
@property (nonatomic,readonly) BOOL isCategory;
@end


