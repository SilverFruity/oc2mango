//
// Created by Jiang on 2019-05-06.
// Copyright (c) 2019 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "Statement.h"

// MARK: - ValueType
typedef enum {
    OCValueObject,
    OCValueSelf,
    OCValueSuper,
    OCValueBlock,
    OCValueSelector,
    OCValueDictionary,
    OCValueArray,
    OCValueNSNumber,
    OCValueString,
    OCValueCString,
    OCValueNumber,
    OCValueConvert,
    OCValueNil,
    OCValueNULL,
    OCValuePointValue,
    OCValueVarPoint,
    OCValueMethodCall,
    OCValueFuncCall
}OC_VALUE_TYPE;

@interface OCValue: NSObject <ValueExpression>
@property (nonatomic,assign)OC_VALUE_TYPE value_type;
@end
typedef enum{
    OCMethodCallNormalCall,
    OCMethodCallDotGet
}OCMethodCallType;

@protocol OCMethodElement <NSObject>
@property (nonatomic, strong)NSMutableArray <id <ValueExpression>> *values;
@end

@interface OCMethodCallNormalElement: NSObject <OCMethodElement>
@property (nonatomic, strong)NSMutableArray *names;
@property (nonatomic, strong)NSMutableArray <id <ValueExpression>> *values;
@end

@interface OCMethodCallGetElement: NSObject <OCMethodElement>
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSMutableArray <id <ValueExpression>> *values;
@end


@interface OCMethodCall : OCValue
@property (nonatomic, strong)OCValue *caller;
@property (nonatomic, strong)id <OCMethodElement> element;
@end



@interface BlockImp : OCValue
@property(nonatomic,strong) TypeSpecial *returnType;
@property(nonatomic,strong) NSMutableArray <VariableDeclare *>*varibles;
@property(nonatomic,strong) FunctionImp *funcImp;
@end
