# oc2mongo
convert Objective-C to mango script:https://github.com/YPLiang19/Mango
# 帮助

如何使用:

```shell
# 先在releases中下载最新的oc2mango.zip
unzip ~/Downloads/oc2mango.zip -d ~/Downloads/
~/Downloads/oc2mango input_dir[包含Objective-C .h .m的文件夹] output_dir[.mg的输出文件夹]
```

## 无法识别

类型转换 不能识别：a = (CFString) a; 。 能识别  a = (CFString *) a;

Tips: 尽量不用使用类型转换。 

## 自动忽略 

@protocol 声明协议

关键字: static, const, enum, struct, typedef,_Nullable, nullable, @required, @optional, @encode等

预编译指令: #define #if 等
