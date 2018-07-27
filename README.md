# JSON-to-Property-Tool

将`JSON`转化为对应的`Objective-C`的模型代码

##1.1新功能
新增 `TrueNumberType` 功能， 默认开启
开启后`JSON`转化时 数字类型将使用真正的类型如 `NSInteger`, `float`, `double`, `BOOL`
关闭后将统一转化为 `NSNumber *`类型
