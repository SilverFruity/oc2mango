//
//  SymbolStack.h
//  oc2mangoLib
//
//  Created by Jiang on 2019/5/23.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Symbol:NSObject
@property (nonatomic,copy)NSString *name;
+ (instancetype)symbolWithName:(NSString *)name;
@end

@interface TypeSymbol:Symbol
@end

@interface VariableSymbol:Symbol
@property (nonatomic,strong)TypeSymbol *type;
@end

@interface FuncSymbolTable: NSObject
- (Symbol *)lookup:(NSString *)key;
- (void)addSymbol:(Symbol *)symbol forKey:(NSString *)key;
@end

@interface FuncSymbolStack : NSObject
- (Symbol *)lookup:(NSString *)key;
- (void)addSymbolToLast:(Symbol *)symbol forKey:(NSString *)key;
- (void)push:(FuncSymbolTable *)funcSymbol;
- (void)pop;
- (FuncSymbolTable *)topTable;
@end
