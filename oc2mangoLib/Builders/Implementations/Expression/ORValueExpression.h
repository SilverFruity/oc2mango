//
// Created by Jiang on 2019-05-06.
// Copyright (c) 2019 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "ORStatement.h"
#import "ORFuncDeclare.h"

// MARK: - ValueType
typedef enum {
    OCValueVariable, // value: NSString
    OCValueClassName, // value: NSString
    OCValueSelf, // value: nil
    OCValueSuper, // value: nil
    OCValueSelector, // value: sel NSString
    OCValueProtocol, // value: String
    OCValueDictionary, // value: Exp Array
    OCValueArray, // value: Exp Array
    OCValueNSNumber, // value: Exp
    OCValueString, // value: NSString
    OCValueCString, // value: NSString
    OCValueInt, // value: NSString
    OCValueDouble, // value: NSString
    OCValueNil, //  value: nil
    OCValueNULL, //  value: nil
    OCValueBOOL, //  value: @"YES" @"NO"
    
    //Class
    OCValueMethodCall,
    OCValueFuncCall,
    OCValueBlock,
    OCValueCollectionGetValue // array[0] , dict[@"key"]
}OC_VALUE_TYPE;

@interface ORValueExpression: ORExpression
@property (nonatomic,assign)OC_VALUE_TYPE value_type;
@property (nonatomic,strong)id value;
@end
typedef enum{
    OCMethodCallNormalCall,
    OCMethodCallDotGet
}OCMethodCallType;


@interface ORMethodCall : ORValueExpression
@property (nonatomic, strong)ORValueExpression *caller;
@property (nonatomic, assign)BOOL isDot;
@property (nonatomic, strong)NSMutableArray *names;
@property (nonatomic, strong)NSMutableArray <ORExpression *> *values;
@end

@interface ORCFuncCall: ORValueExpression
@property (nonatomic, strong)ORValueExpression *caller;
@property (nonatomic, strong)NSMutableArray <ORExpression *>*expressions;
@end

@interface ORBlockImp : ORValueExpression
@property(nonatomic,strong) ORFuncDeclare *declare;
@property(nonatomic,strong) NSMutableArray * statements;
- (void)addStatements:(id)statements;
- (void)copyFromImp:(ORBlockImp *)imp;
@end

@interface ORSubscriptExpression: ORValueExpression
@property (nonatomic, strong)ORValueExpression *caller;
@property (nonatomic, strong)ORExpression * keyExp;
@end
