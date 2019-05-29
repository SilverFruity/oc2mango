//
// Created by Jiang on 2019-05-06.
// Copyright (c) 2019 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "Statement.h"
#import "FuncDeclare.h"

// MARK: - ValueType
typedef enum {
    OCValueVariable,
    OCValueClassType,
    OCValueSelf,
    OCValueSuper,
    OCValueBlock,
    OCValueSelector,
    OCValueProtocol,
    OCValueDictionary, // value -> [[exp,exp]..]
    OCValueArray, // value -> [exp..]
    OCValueNSNumber,
    OCValueString,
    OCValueCString,
    OCValueInt,
    OCValueDouble,
    OCValueConvert,
    OCValueNil,
    OCValueNULL,
    OCValuePointValue,
    OCValueVarPoint,
    OCValueMethodCall,
    OCValueFuncCall,
    OCValueCollectionGetValue // array[0] , dict[@"key"]
}OC_VALUE_TYPE;

@interface OCValue: NSObject <ValueExpression>
@property (nonatomic,assign)OC_VALUE_TYPE value_type;
@property (nonatomic,strong)id value;
@end
typedef enum{
    OCMethodCallNormalCall,
    OCMethodCallDotGet
}OCMethodCallType;


@interface OCMethodCall : OCValue
@property (nonatomic, strong)OCValue *caller;
@property (nonatomic, assign)BOOL isDot;
@property (nonatomic, strong)NSMutableArray *names;
@property (nonatomic, strong)NSMutableArray <id <ValueExpression>> *values;
@end

@interface CFuncCall: OCValue
@property (nonatomic, strong)OCValue *caller;
@property (nonatomic, strong)NSMutableArray <id <ValueExpression>>*expressions;
@end

@interface BlockImp : OCValue
@property(nonatomic,strong) FuncDeclare *declare;
@property(nonatomic,strong) NSMutableArray * statements;
- (void)addStatements:(id)statements;
- (void)copyFromImp:(BlockImp *)imp;
@end

@interface OCCollectionGetValue: OCValue
@property (nonatomic, strong)OCValue *caller;
@property (nonatomic, strong)id <Expression> keyExp;
@end
