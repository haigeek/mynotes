## Oracle常见函数

## 单行函数

#### 字符函数

1. LOWER函数和UPPER函数：

   作用：将字符串转换为大/小写的格式

2. length(char):

   作用：返回字符串的长度

3. initcap函数：

   作用：将字符串中每个单词转换为首字母大写，其余字符小写

4. ASCII函数和CHR函数

   作用：字符和ascii码相互转换

5. substr(char,m,n):

   作用：截取字符串的子串，n代表n个字符的意思，不是代表取到第n个

6. replace(char1, search_string, replace_string)

   作用:替换函数

7. instr(c1,c2,i,j)：

   作用：判断某字符或者字符串是否存在，存在返回出现位置的索引，否则返回小于1；在一个字符串中搜索指定的字符，返回发现指定的字符的位置；C1 被搜索的字符串，C2希望搜索的字符串，I 搜索的开始位置，默认为1，J 出现的位置，默认为1

```sql
select instr('azhangsanbcd', 'zhangsan') from dual; --返回2
select instr('oracle traning', 'ra', 1, 1) instring from dual; --返回2
select instr('oracle traning', 'ra', 1, 2) instring from dual; --返回9
select instr('oracle traning', 'ra', 1, 3) instring from dual; --返回0
select instr('abc','d') from dual;  --返回0
```

8. LPAD函数和RPAD函数：

   作用：LPAD(x,width[,pad_string])，给x左边补充pad_string，直至width长度。

9. LTRIM函数、RTRIM函数和TRIM函数

   格式：LTRIM(x,trim_string])

   作用：从x左边截去trim_string,如果没有第二个参数则截去空格

10. substr函数

   格式：SUBSTR(x，start，length)

   作用：从x中的start开始，截取length长度的子串，如未指明length，则一直截取到x的末尾

#### 空值处理函数

1. NVL函数

   格式：NVL(x,value)

   作用：如果X为null，则返回value，否则返回x

2. NVL2函数

   格式：NVL2(x,value1,value2)

   作用：如果x不为NULL，则返回value1，否则返回value2

### 数值函数

数学函数的输入参数和返回值的数据类型都是数据类型的

1. round(n,[m]) 该函数用于执行四舍五入

   如果省掉m，则四舍五入到整数

   如果m是正数，则四舍五入到小数点的m位后

   如果m是负数，则四舍五入到小数点的m位后

   示例

   ```sql
   SELECT round(23.75123) FROM dual; --返回24
   SELECT round(23.75123, -1) FROM dual; --返回20
   SELECT round(27.75123, -1) FROM dual; --返回30
   SELECT round(23.75123, -3) FROM dual; --返回0
   SELECT round(23.75123, 1) FROM dual; --返回23.8
   SELECT round(23.75123, 2) FROM dual; --返回23.75
   SELECT round(23.75123, 3) FROM dual; --返回23.751
   ```

2. trunc(n,[m])该函数用于截取数字

   如果省掉m，就截去小数部分，
   如果m是正数就截取到小数点的m位后，
   如果m是负数，则截取到小数点的前m位

   ```sql
   SELECT trunc(23.75123) FROM dual; --返回23
   SELECT trunc(23.75123, -1) FROM dual; --返回20
   SELECT trunc(27.75123, -1) FROM dual; --返回20
   SELECT trunc(23.75123, -3) FROM dual; --返回0
   SELECT trunc(23.75123, 1) FROM dual; --返回23.7
   SELECT trunc(23.75123, 2) FROM dual; --返回23.75
   SELECT trunc(23.75123, 3) FROM dual; --返回23.751
   ```

3. mod(m,n)取余函数

4. floor(n) 返回小于或是等于n的最大整数

5. celi(n) 返回大于或是等于n的最小整数

6. abs(n) 返回数字的绝对值

7. power(x,y) 计算x的y次幂

8. sqrt() 计算平方根

#### 数值和字符串转换函数

转换函数用于将数据类型从一种转为另外一种

1. to_char()函数

   格式：TO_CHAR(x [,format])；

   作用：将数值x转化为字符串，format指明转换后的格式

   format中可以使用的转换符：9--代表一位数字；0--代表该位置补零；D--代表小数点符号位置，和.等效；S--代表返回正负号；如果实际整数位数超过格式字符串中的位数，则返回由#组成的字符串。

   示例：

   ```sql
   select TO_CHAR(23456.78954,‘S099999.99')from dual;
   ```

2. TO_NUMBER()函数

   格式： TO_NUMBER(x[,format])

   作用：将字符串x转换为数值

   format说明了字符串的格式。

3. CAST函数

   格式：CAST(x AS type)

   作用：将x转换为type所指定的数据类型

## 日期函数

1. sysdate 返回系统时间

2. add_months函数

   oracle add_months(time,months)函数可以得到某一时间之前或之后n个月的时间

3. last_day(d):返回指定日期所在月份的最后一天

4. MONTHS_BETWEEN(x,y) 返回日期x减去日期y后的月份差。

5. NEXT_DAY(x,day) day--是一个表示星期几的字符串(和nls_date_language有关，如’saturday’ ,’星期六’) 该函数返回从日期x开始，到达下个指定的星期几的日期

#### 日期值和字符串转换函数

1. 使用TO_CHAR(x[,format])将日期值转换为字符串,format字符串用来说明转换后的字符串的格式，如果没有该参数，则使用当前会话中的日期语言和日期格式进行转换。
2. 使用TO_DATE(x[,format])函数将字符串转换为日期值,x--一个日期字符串,format--用来说明字符串中的日期格式。



## 聚合函数

聚合函数可以同时对一组进行操作，并返回操作结果，可以配合使用DISTINCT在计算时取消重复值。

1. AVG:返回平均值
2. COUNT：返回行数
3. MAX：返回最大值
4. MIN：返回最小值
5. SUM：返回和

COUNT,MIN,MAX可应用于数值、字符串和日期数据。AVG和SUM仅能用于数值。

除了count(*),其它聚合函数都会忽略空值。

## 分组聚合

可以使用GROUP BY子句把不同行的数据分成组；如果未对查询结果进行分组，聚合函数将作用与整个查询结果；对查询结果分组后，聚合函数将分别作用于每个组

格式：GROUP BY 字段列表 HAVING <条件表达式>

GROUP BY 对查询结果按字段列表进行分组，字段值相等的记录分为一组，定用于分组的字段列表可以是一列，也可以是多个列，彼此间用逗号分隔；HAVING短语对分组的结果进行过滤，仅输出满足条件的组

示例：

```sql
#查询各个课程号及相应的选课人数
SELECT courseNo, COUNT(studentNo) FROM tb_score GROUP BY courseNo;
#查询每个学生的选课门数、平均分和最高分
SELECT studentNo, COUNT(*) 选课门数, AVG(score) 平均分, MAX(score) 最高分 FROM tb_score GROUP BY studentNo;
#查询学生选课的平均成绩，只取大于80分的才输出
SELECT AVG(score) 平均分 FROM tb_score HAVING AVG(score)>=88;
```