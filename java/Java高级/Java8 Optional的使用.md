# Java8 Optional的使用

在Java8中引入了Optional来避免java的空指针问题

基本方法

`of()` 为非 null 的值创建一个 Optional 实例

`isPresent()` 如果值存在，返回 true，否则返回 false

`get()` 返回该对象，有可能返回 null

`OfNullable()` 如果指定的值为 null，返回一个空的 Optional

`ifPresent()` 如果实例非空，调用 Comsumer Lambda 表达式

`orElse(obj)` 如果实例非空，返回该实例，否则返回 obj

