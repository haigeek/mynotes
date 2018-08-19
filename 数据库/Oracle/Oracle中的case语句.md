# PL/SQL中的case语句和if语句

case语句存在两种形式：case和搜索式case，case语句可以设定选择器， 选择器会决定需要执行哪组动作，而搜索式case语句没有选择器，搜索条件会按顺序计算，从而决定采取哪组动作。

### case语句

case语句的结构

```sql
case selector
	when expression1 then statement1;
	when expression2 then statement2;
	...
	when expression n then statement n;
	else statement N+1
end case;
```

选择器决定哪个WHEN子句应该被执行，每个WHEN子句都包含一个EXPRESSION以及与之关联的一个或者多个可执行语句，else语句是可选的；选择器只会计算一次，会顺序计算WHEN子句，表达式的值与选择器的值进行比较

### 搜索式case语句

搜索式语句有个能产生布尔值的搜索条件，当特定的搜索条件的计算结果为TURE时，会执行与该条件相关的语句组合。

搜索式case语句的结构：

```
case
	when search condition 1 then statement 1;
	when search condition 2 then statement 2;
	...
	when search condition n then statement n;
	else statement N+1;
end case;
```

当搜索条件的计算结果为true时，执行控制权传递给相关的语句，如果任何搜索条件都不会产生true，则会执行与else子句相关的语句

### case语句和搜索式case语句的差别

搜索式case语句没有选择器，除此之外，它的when子句能够产生布尔值的搜索条件（类似if语句）而不会生成任意类型值的表达式

## case表达式

在case语句中，when和else子句包含一个可执行的语句，每个可执行语句的结尾处都是分号，在case表达式中，when和else子句包含的表达式的结尾处不是分号，分号出现在保留字end后面，end终止case表达式

### case when 在语句中不同位置的用法

1. select case when 用法

   ```sql
   SELECT   grade, COUNT (CASE WHEN sex = 1 THEN 1      
                          ELSE NULL
                          END) 男生数,
                   COUNT (CASE WHEN sex = 2 THEN 1
                          ELSE NULL
                          END) 女生数
       FROM students GROUP BY grade;
   ```

2. where case when用法

   ```
   SELECT T2.*, T1.*
      FROM T1, T2
     WHERE (CASE WHEN T2.COMPARE_TYPE = 'A' AND
                      T1.SOME_TYPE LIKE 'NOTHING%'
                   THEN 1
                 WHEN T2.COMPARE_TYPE != 'A' AND
                      T1.SOME_TYPE NOT LIKE 'NOTHING%'
                   THEN 1
                 ELSE 0
              END) = 1
   ```

3. group by case when用法

   ```sql
   SELECT  
   CASE WHEN salary <= 500 THEN '1'  
   WHEN salary > 500 AND salary <= 600  THEN '2'  
   WHEN salary > 600 AND salary <= 800  THEN '3'  
   WHEN salary > 800 AND salary <= 1000 THEN '4'  
   ELSE NULL END salary_class, -- 别名命名
   COUNT(*)  
   FROM    Table_A  
   GROUP BY  
   CASE WHEN salary <= 500 THEN '1'  
   WHEN salary > 500 AND salary <= 600  THEN '2'  
   WHEN salary > 600 AND salary <= 800  THEN '3'  
   WHEN salary > 800 AND salary <= 1000 THEN '4'  
   ELSE NULL END;  
   ```

   ​





#### 

