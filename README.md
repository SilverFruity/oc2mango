## 项目介绍

### 1. oc2mango

​	将Objective-C转换为[MangoFix](https://github.com/YPLiang19/Mango)脚本.

* 输入Objective-C源码文件夹，通过oc2mangoLib转换为AST，再将AST转换为mongo script.

#### 使用示例

```shell
# 先在releases中下载最新的oc2mango.zip
# 解压文件夹
unzip ~/Downloads/oc2mango.zip -d ~/Downloads/
# 执行oc2mango
~/Downloads/oc2mango input_dir[包含Objective-C .h .m的文件夹] output_dir[.mg的输出文件夹]
# 例如: ~/Downloads/oc2mango ~/Desktop/InputOCFilesDir ~/Desktop/OuputMongoFilesDir
```
### 2. PatchGenerator

​	将Objective-C转换为[OCRunner](https://github.com/SilverFruity/OCRunner)热更新补丁.

* 输入Objective-C文件集合或者文件夹，通过oc2mangoLib转换为AST，再使用ORPatchFile，将AST序列化为可被OCRunner执行的二进制补丁或JSON补丁，.

#### 使用示例

* **-files**: Objective-C源文件列表或者文件夹
* **-refs**: 外部引用的文件列表或者是文件夹. 比如：OCRunnerDemo/Scripts.bundle中的UIKit、GCD Refrences.  主要包含一些结构体声明、枚举声明、typedef、系统函数声明.
* **-output**:  补丁文件最终保存的路径

```shell
# 1: -files: files
PatchGenerator -files ~/OCRunnerDemo/ViewController1 ~/OCRunnerDemo/ViewController2 ~/OCRunnerDemo/ViewController3 -refs  ~/Scripts.bundle -output ~/OCRunnerDemo/binarypatch

PatchGenerator -files ~/OCRunnerDemo/ViewController1 -refs  ~/Scripts.bundle -output ~/OCRunnerDemo/binarypatch

# 2: -files: dir
PatchGenerator -files ~/OCRunnerDemo/ViewController1/ -refs ~/Scripts.bundle -output ~/OCRunnerDemo/binarypatch

```

### 3. oc2mangoLib

* 将Objective-C源码，通过flex&bsion转换为语法树

### 4. ORPatchFile

* oc2mango、oc2mangoLib、OCRunner、PatchGenerator的基础库.
* 包含了所有的语法节点类，以及补丁文件的序列化与反序列化. （RunnerClasses、ORPatchFile）.
* 包含两种补丁：二进制补丁和JSON形式的补丁. 
* 其中二进制补丁，反序列化速度和文件大小皆是最优秀.


### 5. BinaryPatchCodeGenerator

* 输入RunnerClasses.h文件，然后生成BinaryPatchHelper.h，BinaryPatchHelper.m两个文件.

## 不支持

1. 预编译相关
2. 编译器内置函数以及属性__attribute__等
3. a[x], {x,y,z}, a->x
4. id a = ( identifier )object; 类型转换. 但支持id a =  (identifier *)object;

除以上列表，其余语法皆已支持。有问题，欢迎提交issue。
