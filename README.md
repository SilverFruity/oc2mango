# oc2mongo
convert Objective-C to mango script:https://github.com/YPLiang19/Mango

# 帮助

## 功能

1. oc2mango将Objective-C转换到mongo script
2. oc2mangoLib.framework将Objective-C转换为语法树
3. 完善的单元测试, 单元测试覆盖率84%

## 如何使用

```shell
# 先在releases中下载最新的oc2mango.zip
unzip ~/Downloads/oc2mango.zip -d ~/Downloads/
~/Downloads/oc2mango input_dir[包含Objective-C .h .m的文件夹] output_dir[.mg的输出文件夹]
# 例如: ~/Downloads/oc2mango ~/Desktop/InputOCFilesDir ~/Desktop/OuputMongoFilesDir
```

## 不支持

1. 预编译相关
2. 协议声明 @protocol
3. 编译器内置函数以及属性__attribute__等
4. 类型强制转换问题: 不能识别：a = (CFString) a; 。 能识别  a = (CFString *) a;
Tips: 尽量不用使用类型转换。 

除以上列表，其余语法皆已支持。有问题，欢迎提交issue。
