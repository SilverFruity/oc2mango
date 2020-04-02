# oc2mongo
convert Objective-C to mango script:https://github.com/YPLiang19/Mango
# 帮助

如何使用:

```shell
unzip ~/Downloads/oc2mango.zip -d ~/Downloads/
sudo mv ~/Downloads/oc2mango/oc2mango /usr/bin/
oc2mango input_dir output_dir
```

## 暂不支持

全局自定义函数

struct

enum

## 无法识别

typedef,  enum, struct

类型转换 不能识别：a = (CFString) a; 。 能识别  a = (CFString *) a;

Tips: 尽量不用使用类型转换。 

## 自动忽略 

@protocol 声明协议

关键字: static, const, enum, struct, typedef,_Nullable, nullable, @required, @optional, @encode等

预编译指令: #define #if 等