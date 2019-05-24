//
//  SymbolStack.m
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/23.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import "SymbolStack.h"

@implementation Symbol
- (instancetype)initWithName:(NSString *)name{
    self = [super init];
    self.name = name;
    return self;
}
+ (instancetype)symbolWithName:(NSString *)name{
    return [[[self class] alloc] initWithName:name];
}
@end

@implementation TypeSymbol


@end

@implementation VariableSymbol


@end

@interface FuncSymbolTable ()
@property (nonatomic,strong)NSMutableDictionary <NSString *,Symbol *> *symbolTable;
@end
@implementation FuncSymbolTable
- (instancetype)init
{
    self = [super init];
    self.symbolTable = [NSMutableDictionary dictionary];
    return self;
}
- (Symbol *)lookup:(NSString *)name{
    return self.symbolTable[name];
}
- (void)addSymbol:(Symbol *)symbol forKey:(NSString *)key{
    self.symbolTable[key] = symbol;
}
- (NSString *)description{
    return [self.symbolTable description];
}
@end

@interface FuncSymbolStack()
@property (nonatomic,strong)NSMutableArray <FuncSymbolTable *> *stack;
@end

@implementation FuncSymbolStack
- (instancetype)init
{
    self = [super init];
    self.stack = [NSMutableArray array];
    [self push:[FuncSymbolTable new]];
    return self;
}
- (Symbol *)lookup:(NSString *)name{
    for (NSUInteger i = self.stack.count; i > 0; i--) {
        FuncSymbolTable *func = self.stack[i - 1];
        if ([func lookup:name]) {
            return [func lookup:name];
        }
    }
    return nil;
}
- (void)addSymbolToLast:(Symbol *)symbol forKey:(NSString *)key{
    [self.stack.lastObject addSymbol:symbol forKey:key];
}
- (void)push:(FuncSymbolTable *)funcSymbol{
    [self.stack addObject:funcSymbol];
}
- (void)pop{
    [self.stack removeLastObject];
}
- (FuncSymbolTable *)topTable{
    return self.stack.lastObject;
}
@end
