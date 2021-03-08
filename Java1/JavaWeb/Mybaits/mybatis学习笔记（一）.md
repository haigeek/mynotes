# mybatis学习笔记（一）

## mybatis框架

### 操作流程

- SqlMapConfig.xml(mybatis的全局配置文件)，配置数据源，事务等mybatis运行环境，配置映射文件（配置sql语句）mapper.xml（映射文件）
- SQLSessionFactory（会话工厂） 作用：创建SQLSession
- SQLSession（会话） 作用 操作数据库（发出sql 增删改查）
- Executor（执行器） SqlSession内部通过执行器操作数据库
- mapped statement（底层封装对象） 对数据库存储封装，包括sql语句，输入参数、输出结果类型

