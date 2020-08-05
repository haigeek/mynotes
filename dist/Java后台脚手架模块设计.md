# Java后台脚手架模块设计

## base模块

base包划分类型

需要有的模块

- Exception模块
- Constants模块
- Util模块,根据功能进行细分

## API包

- API包可以有自己的异常和工具类
- 在Api模块去除Entity包

## 业务模块

业务模块可以有自己的异常和utils