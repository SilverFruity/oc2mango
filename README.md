# oc2mongo
convert Objective-C to mango script:https://github.com/YPLiang19/Mango
# 帮助

不支持预编译指令 #define #if 等等

不支持关键字: static, const, enum, struct, typedef,_Nullable, nullable, @required, @optional, @encode等

支持写法: NSArray <NSArray*> *array, 不支持 NSArray <NSArray<id> *> *array;

当前对于typedef, enum, struct等声明的类型，无法进行判断，代码中仍会以原名称展示。
