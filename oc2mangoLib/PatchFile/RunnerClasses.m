//
//  ORunner.m
//  MangoFix
//
//  Created by Jiang on 2020/4/26.
//  Copyright © 2020 yongpengliang. All rights reserved.
//

#import "RunnerClasses.h"
@implementation ORTypeNode
+ (instancetype)specialWithType:(TypeKind)type name:(NSString *)name{
    ORTypeNode *s = [ORTypeNode new];
    s.type = type;
    s.name = name;
    return s;
}
@end
@implementation ORVariableNode
@end
@implementation ORFunctionDeclNode
@end
@implementation ORNode
@end
@implementation ORValueNode
@end

@implementation ORIntegerValue
@end

@implementation ORUIntegerValue: ORNode
@end

@implementation ORDoubleValue
@end

@implementation ORBoolValue
@end

@interface ORMethodCall()
@property (nonatomic, copy)NSString *selectorName;
@end
@implementation ORMethodCall
- (NSString *)selectorName{
    if (_selectorName == nil){
        NSMutableArray *names = [self.names mutableCopy];
        if (self.values.count >= 1){
            [names addObject:@""];
        }
        _selectorName = [names componentsJoinedByString:@":"];
    }
    return _selectorName;
}
@end
@implementation ORFunctionCall
@end

@implementation ORBlockNode
- (instancetype)init
{
    self = [super init];
    self.statements = [NSMutableArray array];
    return self;
}
- (void)addStatements:(id)statements{
    if ([statements isKindOfClass:[NSArray class]]) {
        [self.statements addObjectsFromArray:statements];
    }else{
        [self.statements addObject:statements];
    }
}
- (void)copyFromImp:(ORBlockNode *)imp{
    self.statements = imp.statements;
}

@end
@implementation ORFunctionNode
- (instancetype)normalFunctionImp{
    ORFunctionNode *imp = [ORFunctionNode new];
    imp.declare = [self.declare copy];
    imp.scopeImp = self.scopeImp;
    imp.declare.var.isBlock = NO;
    return imp;
}
- (BOOL)isBlockImp{
    return self.declare.var.isBlock;
}
@end
@implementation ORSubscriptNode
@end
@implementation ORAssignExpression
- (NSString *)varname{
    if ([self.value isKindOfClass:[ORValueNode class]]) {
        return [(ORValueNode *)self.value value];
    }
    return nil;
}
@end
@implementation ORDeclaratorNode
- (NSUInteger)hash{
    return [self.var.varname hash];
}
- (BOOL)isEqual:(id)object{
    return [self hash] == [object hash];
}
+ (instancetype)copyFromDecl:(ORDeclaratorNode *)var{
    __autoreleasing ORDeclaratorNode *new = [[self class] new];
    new.type = var.type;
    new.var = var.var;
    return new;
}
@end
@implementation ORInitDeclaratorNode
@end

@implementation ORUnaryExpression
@end
@implementation ORBinaryExpression
@end
@implementation ORTernaryExpression
- (instancetype)init
{
    self = [super init];
    self.values = [NSMutableArray array];
    return self;
}
@end

@implementation ORIfStatement
@end
@implementation ORWhileStatement
@end
@implementation ORDoWhileStatement
@end
@implementation ORCaseStatement
@end
@implementation ORSwitchStatement
- (instancetype)init
{
    self = [super init];
    self.cases = [NSMutableArray array];
    return self;
}
@end
@implementation ORForStatement
@end
@implementation ORForInStatement
@end
@implementation ORControlStatNode
@end

@implementation ORPropertyNode
- (MFPropertyModifier)modifier{
    NSDictionary *cache = @{
        @"strong":@(MFPropertyModifierMemStrong),
        @"weak":@(MFPropertyModifierMemWeak),
        @"copy":@(MFPropertyModifierMemCopy),
        @"assign":@(MFPropertyModifierMemAssign),
        @"nonatomic":@(MFPropertyModifierNonatomic),
        @"atomic":@(MFPropertyModifierAtomic)
    };
    uint32_t value = 0;
    for (NSString *keyword in self.keywords) {
        NSNumber *keywordValue = cache[keyword];
        if (keywordValue) {
            value = value | keywordValue.unsignedIntValue;
        }
    }
    return value;
}
- (NSUInteger)hash{
    return [self.var hash];
}
- (BOOL)isEqual:(ORPropertyNode *)object{
    return [self hash] == [object hash];
}
@end
@interface ORMethodDeclNode()
@property (nonatomic, copy)NSString *selectorName;
@end
@implementation ORMethodDeclNode
- (NSString *)selectorName{
    if (_selectorName == nil){
        NSMutableArray *names = [self.methodNames mutableCopy];
        if (self.parameterNames.count >= 1){
            [names addObject:@""];
        }
        _selectorName = [names componentsJoinedByString:@":"];
    }
    return _selectorName;
}
@end
@implementation ORMethodNode
- (NSUInteger)hash{
    return [[self.declare selectorName] stringByAppendingFormat:@"%d",self.declare.isClassMethod].hash;
}
- (BOOL)isEqual:(id)object{
    return [self hash] == [object hash];
}
@end
@implementation ORClassNode
+ (instancetype)classNodeWithClassName:(NSString *)className{
    ORClassNode *class = [ORClassNode new];
    class.className = className;
    return class;
}
- (instancetype)init
{
    self = [super init];
    self.properties  = [NSMutableArray array];
    self.privateVariables = [NSMutableArray array];
    self.properties = [NSMutableArray array];
    self.methods = [NSMutableArray array];
    
    return self;
}
- (void)merge:(ORClassNode *)target key:(nonnull NSString *)key{
    NSMutableSet *sourceSet = [NSMutableSet setWithArray:[self valueForKey:key]];
    NSMutableSet *compredSet = [NSMutableSet setWithArray:[target valueForKey:key]];
    [compredSet unionSet:sourceSet];
    [compredSet minusSet:sourceSet];
    NSMutableArray *array = [self valueForKey:key];
    [array addObjectsFromArray:compredSet.allObjects];
}
@end
@implementation ORProtocolNode
+ (instancetype)protcolWithProtcolName:(NSString *)protcolName{
    ORProtocolNode *protcol = [ORProtocolNode new];
    protcol.protcolName = protcolName;
    return protcol;
}
- (instancetype)init
{
    self = [super init];
    self.properties  = [NSMutableArray array];
    self.properties = [NSMutableArray array];
    self.methods = [NSMutableArray array];
    return self;
}
@end

@implementation ORStructStatNode

@end

@implementation ORUnionStatNode

@end

@implementation OREnumStatNode

@end

@implementation ORTypedefStatNode

@end

@implementation ORCArrayDeclNode

@end
